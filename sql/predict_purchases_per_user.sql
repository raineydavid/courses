#standardSQL
/*
You'll realize the SELECT and FROM portions of the query is identical to that used during training. 

The WHERE portion reflects the change in time frame and the FROM portion shows that you're calling ml.EVALUATE.

If used with a linear regression model, the above query returns the following columns:

mean_absolute_error, mean_squared_error, mean_squared_log_error, median_absolute_error, r2_score, explained_variance. 

If used with a logistic regression model, the above query returns the following columns:

precision, recall accuracy, f1_score log_loss, roc_auc 

Please consult the machine learning glossary or run a Google search to understand how each of these metrics are calculated and what they mean.
*/
SELECT
  fullVisitorId,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL `bqml_lab.sample_model`, (
SELECT
  IFNULL(device.operatingSystem, "") AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, "") AS country,
  fullVisitorId
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY fullVisitorId
ORDER BY total_predicted_purchases DESC
LIMIT 10;
