#!/bin/bash

set -o errexit
cd `dirname $0`
eval `./admin/ShowDBDefs`

if [ "$DB_SCHEMA_SEQUENCE" != "14" ]
then
    echo `date` : Error: Schema sequence must be 14 when you run this script
    exit -1
fi

if [ "$REPLICATION_TYPE" = "$RT_MASTER" ]
then
    echo `date` : Export pending db changes
    ./admin/RunExport

    echo `date` : Drop replication triggers
    ./admin/psql READWRITE < ./admin/sql/DropReplicationTriggers.sql
fi

echo `date` : Applying 20120420-editor-improvements.sql
./admin/psql < admin/sql/updates/20120420-editor-improvements.sql

echo `date` : Appyling 20120417-improved-aliases.sql
./admin/psql < admin/sql/updates/20120417-improved-aliases.sql

echo `date` : Applying 20120423-release-group-types.sql
./admin/psql < admin/sql/updates/20120423-release-group-types.sql

echo `date` : Applying 20120320-remove-url-refcount.sql
./admin/psql < admin/sql/updates/20120320-remove-url-refcount.sql

echo `date` : 20120410-multiple-iswcs-per-work.sql
./admin/psql < admin/sql/updates/20120410-multiple-iswcs-per-work.sql

echo `date` : 20120430-timeline-events.sql
./admin/psql < admin/sql/updates/20120430-timeline-events.sql

echo `date` : 20120501-timeline-events.sql
./admin/psql < admin/sql/updates/20120501-timeline-events.sql

echo `date` : Applying 20120405-rename-language-columns.sql
./admin/psql < admin/sql/updates/20120405-rename-language-columns.sql

echo `date` : Running 20120406-update-language-codes.pl
./admin/sql/updates/20120406-update-language-codes.pl

echo `date` : Applying 20120411-add-work-language.sql
./admin/psql < admin/sql/updates/20120411-add-work-language.sql

echo `date` : Applying 20120314-add-tracknumber.sql
./admin/psql < admin/sql/updates/20120314-add-tracknumber.sql

echo `date` : Applying 20120412-add-ipi-tables.sql
./admin/psql < admin/sql/updates/20120412-add-ipi-tables.sql

echo `date` : Applying 20120508-unknown-end-dates.sql
./admin/psql < admin/sql/updates/20120508-unknown-end-dates.sql

if [ "$REPLICATION_TYPE" = "$RT_MASTER" ]
then
    echo `date` : Create replication triggers
    ./admin/psql READWRITE < ./admin/sql/CreateReplicationTriggers.sql
fi

if [ "$REPLICATION_TYPE" != "$RT_SLAVE" ]
then
    echo `date` : Applying 20120508-unknown-end-dates-constraints.sql
    ./admin/psql < admin/sql/updates/20120508-unknown-end-dates-constraints.sql

    echo `date` : Applying 20120411-add-work-language-constraints.sql
    ./admin/psql < admin/sql/updates/20120411-add-work-language-constraints.sql

    echo `date` : Applying 20120412-add-ipi-tables-constraints.sql
    ./admin/psql < admin/sql/updates/20120412-add-ipi-tables-constraints.sql

    echo `date` : 20120410-multiple-iswcs-per-work.sql
    ./admin/psql < admin/sql/updates/20120410-multiple-iswcs-per-work-constraints.sql

    echo `date` : Applying 20120423-release-group-types-constraints.sql
    ./admin/psql < admin/sql/updates/20120423-release-group-types-constraint.sql

    echo `date` : Appyling 20120417-improved-aliases-constraints.sql
    ./admin/psql < admin/sql/updates/20120417-improved-aliases-constraints.sql
fi

DB_SCHEMA_SEQUENCE=15
echo `date` : Going to schema sequence $DB_SCHEMA_SEQUENCE
echo "UPDATE replication_control SET current_schema_sequence = $DB_SCHEMA_SEQUENCE;" | ./admin/psql READWRITE

echo `date` : Done
echo `date` : UPDATE THE DB_SCHEMA_SEQUENCE IN DBDefs.pm TO $DB_SCHEMA_SEQUENCE !

# eof
