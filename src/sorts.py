import pandas as pd

with open("meta.yml", "r") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "los: " in line:
        los_path = line.split(": ")[1][:-1]
        df_los = pd.read_csv(los_path, sep=",")
        df_los = df_los.sort_values(by="description")
        los_str = "los:\n"
        for index, row in df_los.iterrows():
            los_str += r"""- sym: %s
  abb: %s
  descr: %s
""" % (row["symbol"], row["unit"], row["description"])

        lines[i] = los_str


for i, line in enumerate(lines):
    if "loa: " in line:
        loa_path = line.split(": ")[1][:-1]
        df_loa = pd.read_csv(loa_path, sep=",")
        df_loa = df_loa.sort_values(by="abbreviation")
        loa_str = "loa:\n"
        for index, row in df_loa.iterrows():
            loa_str += r"""- abb: %s
  short: %s
  long: %s
""" % (row["abbreviation"], row["short"], row["long"])

        lines[i] = "\n" + loa_str

with open(".meta.yml", "w") as f:
    f.writelines(lines)
