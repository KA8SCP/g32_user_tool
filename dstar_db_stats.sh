#!/bin/bash

# Connection settings (edit as needed)

DB_NAME="dstar_global"
DB_USER="dstar"
DB_HOST="localhost"

# Output files

OUT1="/var/www/html/registered_users.html"
OUT2="/var/www/html/registration_delete_status.html"

# Common HTML header

HTML_HEADER='

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Database Report</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; background: #f9f9f9; }
h1, h2, h3 { color: #333; }
table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
th { background-color: #eee; }
tr:nth-child(even) { background-color: #f2f2f2; }
.footer { margin-top: 20px; font-size: 0.9em; color: #666; }
</style>
</head>
<body>
'

HTML_FOOTER='

</body>
</html>
'

# Generate first report

{
echo "$HTML_HEADER"
echo "<h1>Registered Users Report</h1>"
echo "<p>Generated at: $(date)</p>"

psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" <<EOF
\pset format html
\pset border 1

SELECT user_cs, mod_date, reg_date, user_name
FROM unsync_user_mng
WHERE regist_flg = true
AND admin_flg = false
ORDER BY reg_date;

\qecho <h2>Registered Users and Terminals</h2>

SELECT *
FROM sync_mng
WHERE regist_rp_cs LIKE 'W1MRA%'
AND del_flg = false
ORDER BY target_cs;
EOF

echo "<div class='footer'>End of report - $(date)</div>"
echo "$HTML_FOOTER"
} > "$OUT1"

# Generate second report

{
echo "$HTML_HEADER"
echo "<h1>Registration / Deletion Status</h1>"
echo "<p>Generated at: $(date)</p>"

psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" <<EOF
\pset format html
\pset border 1

\qecho <h2>Registration Requests</h2>

SELECT *
FROM unsync_user_mng
WHERE regist_flg = false;

\qecho <h2>Marked For Deletion -- System Wide</h2>

SELECT *
FROM sync_mng
WHERE del_flg = true;
EOF

echo "<div class='footer'>End of report - $(date)</div>"
echo "$HTML_FOOTER"
} > "$OUT2"

echo "Reports generated:"
echo " - $OUT1"
echo " - $OUT2"
