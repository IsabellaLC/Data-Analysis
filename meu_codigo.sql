

CREATE DATABASE financial_analysis;
GO

-- csv exported as flatfile --
SELECT * FROM financial_analysis.dbo.first_checkout;

--id--
ALTER TABLE financial_analysis.dbo.second_checkout
ADD id INT IDENTITY(1,1);

-- fixing float values --
ALTER TABLE financial_analysis.dbo.second_checkout
ALTER COLUMN avg_last_week FLOAT;
SELECT * FROM financial_analysis.dbo.second_checkout;

ALTER TABLE financial_analysis.dbo.first_checkout
ALTER COLUMN avg_last_month FLOAT;
SELECT * FROM financial_analysis.dbo.first_checkout;

-- creating status and deviation columns--

ALTER TABLE financial_analysis.dbo.second_checkout
ADD average_deviation FLOAT,
    day_status VARCHAR(20),
    anomaly_status VARCHAR(20);
    last_week_comparison VARCHAR(20);

UPDATE financial_analysis.dbo.first_checkout
SET average_deviation = today - avg_last_week,
    day_status = CASE
        WHEN today > yesterday THEN 'Increase'
        WHEN today < yesterday THEN 'Decrease'
        ELSE 'Not Changed'
    END;
    
UPDATE financial_analysis.dbo.first_checkout
SET     anomaly_status = CASE
        WHEN today > avg_last_week * 1.5 THEN 'High Anomaly'
        WHEN today < avg_last_week THEN 'Low Anomaly'
        ELSE 'Normal'
    END;

UPDATE financial_analysis.dbo.first_checkout
SET last_week_comparison = CASE
        WHEN today > same_day_last_week THEN 'Increase'
        WHEN today < same_day_last_week THEN 'Decrease'
        ELSE 'Not Changed'
    END;

ALTER TABLE financial_analysis.dbo.first_checkout
ADD weekly_growth_ratio FLOAT;
UPDATE financial_analysis.dbo.first_checkout
SET weekly_growth_ratio = 
    CASE 
        WHEN same_day_last_week <> 0 
        THEN today / same_day_last_week
        ELSE NULL
    END;