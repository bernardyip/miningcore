SET ROLE miningcore;

CREATE TABLE shares_btc1 PARTITION OF shares FOR VALUES IN ('btc1');
