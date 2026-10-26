import os
import sqlite3
import requests


class WaterClass:
    """Reservoir water quality database built from Taiwan's open data API.

    Set the API key before use:  export EPA_API_KEY=your_key_here
    A free key can be registered at https://data.epa.gov.tw
    """

    BASE_URL = 'https://data.epa.gov.tw/api/v2/wqx_p_03'

    @property
    def API_URL(self):
        api_key = os.environ.get('EPA_API_KEY')
        if not api_key:
            raise RuntimeError(
                'EPA_API_KEY is not set. Register a free key at '
                'https://data.epa.gov.tw and run: export EPA_API_KEY=your_key_here'
            )
        return (f'{self.BASE_URL}?api_key={api_key}'
                '&limit=1000&sort=ImportDate%20desc&format=JSON')

    def __init__(self, db_name='WQ.db'):
        self.db_connection = sqlite3.connect(db_name)
        self.create_table()
        self.import_data()

    def create_table(self):
        cursor = self.db_connection.cursor()
        cursor.execute('''CREATE TABLE IF NOT EXISTS Flow
                          (sitename TEXT, damname TEXT, county TEXT, sampledate TEXT,
                           itemname TEXT, itemengabbreviation TEXT, itemvalue NUMERIC,
                           itemunit TEXT, chk TEXT)''')
        self.db_connection.commit()

    @staticmethod
    def clean_value(raw):
        """Return a float, or None when the value is not recorded."""
        if raw is None:
            return None
        text = str(raw).strip()
        if text in ('', '-'):
            return None
        text = text.replace('<', '')                # '<4.0' -> '4.0'
        try:
            return float(text)                      # always store a real number
        except ValueError:
            return None

    def import_data(self):
        response = requests.get(self.API_URL)
        payload = response.json()
        records = payload.get('records', []) if isinstance(payload, dict) else payload

        cursor = self.db_connection.cursor()
        cursor.execute('DELETE FROM Flow')          # rebuild on every run, no duplicates
        for record in records:
            itemvalue = self.clean_value(record.get('itemvalue'))
            chk = 'T' if itemvalue is not None else 'F'
            cursor.execute('INSERT INTO Flow VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                           (record.get('sitename'),
                            record.get('damname'),
                            record.get('county'),
                            record.get('sampledate'),
                            record.get('itemname'),
                            record.get('itemengabbreviation'),
                            itemvalue,
                            record.get('itemunit'),
                            chk))
        self.db_connection.commit()
        print('資料庫已建立')                        # only after the import finishes

    def warning_site(self, ItemEng, threshold):
        cursor = self.db_connection.cursor()
        cursor.execute("""SELECT sitename, damname, itemvalue
                          FROM Flow
                          WHERE itemengabbreviation = ? AND chk = 'T' AND itemvalue > ?""",
                       (ItemEng, threshold))
        data = cursor.fetchall()
        if not data:
            print('查無資料')
        else:
            for record in data:
                print(record)

    def query_wq(self, Site, ItemEng):
        cursor = self.db_connection.cursor()
        cursor.execute("""SELECT COUNT(DISTINCT sitename), MAX(itemname),
                                 AVG(itemvalue), MAX(itemunit)
                          FROM Flow
                          WHERE damname = ? AND itemengabbreviation = ?""",
                       (Site, ItemEng))
        site_count, item_name, avg_value, item_unit = cursor.fetchone()
        if avg_value is not None:
            avg_value = round(avg_value, 3)
        print((site_count, item_name, avg_value, item_unit))

    def check_data(self, Site, ItemEng):
        cursor = self.db_connection.cursor()
        cursor.execute("""SELECT COUNT(DISTINCT sitename),
                                 COUNT(DISTINCT sitename)
                                 - COUNT(DISTINCT CASE WHEN chk = 'T' THEN sitename END)
                          FROM Flow
                          WHERE damname = ? AND itemengabbreviation = ?""",
                       (Site, ItemEng))
        site_count, null_site_count = cursor.fetchone()
        if site_count == 0:
            print('查無資料')
            return
        print(round(null_site_count / site_count, 3))   # float division in Python
