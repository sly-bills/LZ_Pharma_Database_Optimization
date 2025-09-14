EXPLAIN ANALYZE
SELECT * FROM inventory.drugs d
JOIN research.approvals a USING(drug_id)
WHERE status = 'Approved';

SELECT * FROM  research.approvals;