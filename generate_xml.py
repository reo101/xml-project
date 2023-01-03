import csv

# Read in the CSV data
with open('data.csv', 'r') as f:
    reader = csv.DictReader(f, delimiter='|')
    data = list(reader)

# Extract the unique types and regions from the data
types = set(row['Type'] for row in data)
regions = set(row['Region'] for row in data)

# clean
def clean(s):
    return s.lower().replace(" ", "_").replace(".", "")

# Generate the XML output

# Generate the entities list
entities = ''.join(f'  <!ENTITY restaurant{i}_image SYSTEM "./res/restaurant{i}.jpg" NDATA jpeg>\n' for i in range(1, 1+len(data)))

# Generate initial elements and DTD for the entities
output = (
    '<?xml version="1.0" encoding="UTF-8"?>\n'
    '<?xml-stylesheet href="restaurants.xsl" type="text/xsl"?>\n\n'
    '<!DOCTYPE catalogue [\n'
    '  <!NOTATION jpeg SYSTEM "image/jpeg">\n'
    f'{entities}'
    ']>\n\n'
)

# Generate root
output += '<catalogue>\n'

# Generate the "types" element
output += '  <types>\n'
for t in types:
    output += f'    <type id="{clean(t)}">{t}</type>\n'
output += '  </types>\n'

# Generate the "regions" element
output += '  <regions>\n'
for r in regions:
    output += f'    <region id="{clean(r)}">{r}</region>\n'
output += '  </regions>\n'

# Generate the "restaurants" element
output += '  <restaurants>\n'
for i, row in enumerate(data, 1):
    output += f'    <restaurant id="restaurant{i}">\n'
    output += f'      <name>{row["Name"]}</name>\n'
    output += f'      <type idref="{clean(row["Type"])}"/>\n'
    output += f'      <region idref="{clean(row["Region"])}"/>\n'
    output += f'      <address>{row["Address"]}</address>\n'
    output += f'      <rating>{row["Rating"]}</rating>\n'
    output += f'      <image source="restaurant{i}_image"/>\n'
    output += '    </restaurant>\n'
output += '  </restaurants>\n'

output += '</catalogue>\n'

# Save the XML output to a file
with open('restauraKURnts.xml', 'w') as f:
    f.write(output)