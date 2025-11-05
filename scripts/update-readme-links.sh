#!/bin/bash

MARKDOWN_CONTENT=""
for year in calendars/*/; do
    year=$(basename "$year")
    MARKDOWN_CONTENT+="\n### [$year](./calendars/$year/)\n\n"
    for calendar in calendars/"$year"/*.ics; do
        calendar_name=$(basename "$calendar" .ics)
        calendar_url="https://raw.githubusercontent.com/Syriiin/owc-calendar-helper/refs/heads/master/calendars/$year/$calendar_name.ics"
        MARKDOWN_CONTENT+="- [$calendar_name.ics]($calendar_url)\n"
    done
done

# replace the calendar links section in README.md
README_CONTENT=$(<README.md)
START_MARKER="<!-- CALENDAR LINKS START -->"
END_MARKER="<!-- CALENDAR LINKS END -->"
UPDATED_README_CONTENT=$(echo "$README_CONTENT" | awk -v start="$START_MARKER" -v end="$END_MARKER" -v links="$MARKDOWN_CONTENT" '
    BEGIN {in_section=0}
    {
        if ($0 ~ start) {
            print $0
            print links
            in_section=1
        } else if ($0 ~ end) {
            in_section=0
            print $0
        } else if (in_section == 0) {
            print $0
        }
    }
')
echo -e "$UPDATED_README_CONTENT" > README.md
