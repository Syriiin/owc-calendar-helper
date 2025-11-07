import os
import shutil
from datetime import datetime, timezone

import jinja2

stage_ordering = [
    "Grand Finals",
    "Finals",
    "Semifinals",
    "Quarterfinals",
    "Round Of 16",
    "Round Of 32",
    "Round Of 64",
    "Group Stage",
    "Group Stage Week 2",
    "Group Stage Week 1",
    "Qualifiers",
]

calendars = []

# Load the calendars
calendars_years = os.listdir("calendars")
for calendars_year in sorted(calendars_years, reverse=True):
    stages = os.listdir(os.path.join("calendars", calendars_year))
    calendars.append(
        {
            "year": calendars_year,
            "stages": sorted(
                [
                    {
                        "stage": stage.split(".")[0].title().replace("_", " "),
                        "calendar": os.path.join("calendars", calendars_year, stage),
                    }
                    for stage in stages
                ],
                key=lambda x: stage_ordering.index(x["stage"]),
            ),
        }
    )

# Get last updated date in ISO format UTC
last_updated = datetime.now(tz=timezone.utc).isoformat()

# Load the template
template = jinja2.Template(open("website/templates/index.html.jinja").read())

# Render the template with the provided context
rendered_template = template.render(
    {"calendars": calendars, "last_updated": last_updated}
)

# Create the site directory
shutil.rmtree("site", ignore_errors=True)
os.makedirs("site")

# Write the rendered template to a file
with open("site/index.html", "w") as f:
    f.write(rendered_template)

# Copy calendars to the site directory
shutil.copytree("calendars", "site/calendars")

# Copy static files to the site directory
shutil.copytree("website/static", "site/static")
