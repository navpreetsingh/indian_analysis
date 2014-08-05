TRUNCATE TABLE `nse_year_details`;
TRUNCATE TABLE `nse_month_details`;
TRUNCATE TABLE `nse_week_details`;


INSERT INTO `nse_year_details` (nse_stock_id, year, open, high, low, close, volume)
SELECT nse_stock_id, DATE_FORMAT(date, "%Y") as year, 
SUBSTRING_INDEX( GROUP_CONCAT( CAST( OPEN AS CHAR ) ORDER BY DATE ) ,  ',', 1 ) AS OPEN, 
max(high) AS high, min(low) AS low, 
SUBSTRING_INDEX(GROUP_CONCAT(CAST(close AS CHAR) ORDER BY date DESC), ',', 1) AS close, 
sum(volume) AS volume 
FROM `nse_dumps` 
WHERE nse_stock_id in (
SELECT id FROM `nse_stocks`
where vol_category >= 2
and useless_stock=1
)  
GROUP BY DATE_FORMAT(date, "%Y"),
nse_stock_id 
ORDER by nse_stock_id ASC;

update `nse_year_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = 1 where close > open;

update `nse_year_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = -1 where close <= open;


INSERT INTO `nse_month_details` (nse_stock_id, date, open, high, low, close, volume, date1)
SELECT nse_stock_id, DATE_FORMAT(date, "%M, %Y") as date, 
SUBSTRING_INDEX( GROUP_CONCAT( CAST( OPEN AS CHAR ) ORDER BY DATE ) ,  ',', 1 ) AS OPEN, 
max(high) AS high, min(low) AS low, 
SUBSTRING_INDEX(GROUP_CONCAT(CAST(close AS CHAR) ORDER BY date DESC), ',', 1) AS close, 
sum(volume) AS volume,
MAX(date) AS date1 
FROM `nse_dumps` 
WHERE nse_stock_id in (
SELECT id FROM `nse_stocks`
where vol_category >= 2
and useless_stock=1
)  
GROUP BY DATE_FORMAT(date, "%M, %Y"),
nse_stock_id 
ORDER by nse_stock_id, date1 asc;


update `nse_month_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = 1 where close > open;

update `nse_month_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = -1 where close <= open;



INSERT INTO `nse_week_details` (nse_stock_id, date, open, high, low, close, volume, date1)
SELECT nse_stock_id, DATE_FORMAT(date, "%X Week: %V") as date, 
SUBSTRING_INDEX( GROUP_CONCAT( CAST( OPEN AS CHAR ) ORDER BY DATE ) ,  ',', 1 ) AS OPEN, 
max(high) AS high, min(low) AS low, 
SUBSTRING_INDEX(GROUP_CONCAT(CAST(close AS CHAR) ORDER BY date DESC), ',', 1) AS close, 
sum(volume) AS volume,
MAX(date) AS date1 
FROM `nse_dumps` 
WHERE nse_stock_id in (
SELECT id FROM `nse_stocks`
where vol_category >= 2
and useless_stock=1
)  
GROUP BY DATE_FORMAT(date, "%X Week: %V"),
nse_stock_id 
ORDER by nse_stock_id, date1 asc;


update `nse_week_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = 1 where close > open;

update `nse_week_details`
set oh_diff = (((high - open) / open) * 100),
ol_diff = (((low - open) / open) * 100),
oc_diff = (((close - open) / open) * 100),
bs_signal = -1 where close <= open;

