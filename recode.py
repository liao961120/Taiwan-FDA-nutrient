'''As of 2024/03/21, the data contains duplicated "整合編號" J0707101, mapping to
   both "鮪魚肚" and "旗魚肚" in "樣品名稱". The script here is to recode 
   (J0707101, 旗魚肚) into (J0707102, 旗魚肚) to fix the duplication.
'''

import csv

INFILE = "raw/20_2.csv"
RECODEED_FILE = "made/data.csv"
RECODE_MAP = {
        ('J0707101', '旗魚肚'): 'J0707102',
}

data = []
with open(INFILE, newline="", encoding="UTF-8") as f:
    reader = csv.DictReader(f)
    for r in reader:
        nr = r.copy()
        k = (r["整合編號"], r["樣品名稱"])
        nr["整合編號"] = RECODE_MAP.get(k, r["整合編號"])
        data.append( nr.values() )
data = [ reader.fieldnames ] + data

with open(RECODEED_FILE, "w", newline="", encoding="UTF-8") as f:
    writer = csv.writer(f, delimiter=",")
    writer.writerows(data)
