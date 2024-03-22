Taiwan-FDA-nutrient
===================

- <https://data.gov.tw/dataset/8543>
- <https://consumer.fda.gov.tw/Food/TFND.aspx?nodeID=178>
- 「國人膳食營養素參考攝取量」第八版: <https://www.hpa.gov.tw/Pages/Detail.aspx?nodeid=4248&pid=12285>


## Build

Download CSV data from <https://data.gov.tw/dataset/8543> and place it in `raw/20_2.csv`.
Then, execute the commands below:

```sh
python recode.py
Rscript restructure.R
```

The scripts above structure the original data into formats with `整合編號` (`樣品名稱`) as the primary (i.e., top-level) entries. See the data in `made/` for the outputs.
