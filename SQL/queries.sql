-- S2a: Average resolution time by department

SELECT
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets tk
JOIN teams tm ON tk.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC;

+------------+----------------------+
| department | avg_resolution_hours |
+------------+----------------------+
| Technical  |                28.33 |
| Service    |                19.33 |
+------------+----------------------+



-- S2b: Teams breaching SLA: Use GROUP BY and HAVING

SELECT
    tk.team_id,
    tm.team,
    tm.department,
    ROUND(AVG(tk.resolution_hours), 2) AS avg_resolution_hours
FROM tickets tk
JOIN teams tm ON tk.team_id = tm.team_id
GROUP BY tk.team_id, tm.team, tm.department
HAVING AVG(tk.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC;

+---------+-------------+------------+----------------------+
| team_id | team        | department | avg_resolution_hours |
+---------+-------------+------------+----------------------+
| T3      | AppSupport  | Technical  |                28.67 |
| T4      | DeviceHelp  | Technical  |                28.00 |
| T2      | BillingHelp | Service    |                26.67 |
+---------+-------------+------------+----------------------+


-- S2c: Top two channels by breach count
      -- where resolution_hours > 24


SELECT
    channel,
    COUNT(*) AS breach_count
FROM tickets
WHERE resolution_hours > 24
GROUP BY channel
ORDER BY breach_count DESC, channel ASC
LIMIT 2;

+---------+--------------+
| channel | breach_count |
+---------+--------------+
| Chat    |            3 |
| Phone   |            2 |
+---------+--------------+



-- Summary: count unmatched keys (expect 0)

SELECT
    COUNT(*) AS unmatched_team_ids
FROM tickets tk
LEFT JOIN teams tm ON tk.team_id = tm.team_id
WHERE tm.team_id IS NULL;

+--------------------+
| unmatched_team_ids |
+--------------------+
|                  0 |
+--------------------+