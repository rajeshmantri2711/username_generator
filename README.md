# username_generator

Generates common username permutations from first, middle, and last names.

## Download

Fetch the script:

```bash
curl -O https://raw.githubusercontent.com/rajeshmantri2711/username_generator/main/username.py
```

## Usage

```bash
python username.py -i INFILE
python username.py -N "NAME"
python username.py -i INFILE -o OUTFILE
```

## Options

| Flag | Description |
|------|-------------|
| `-i INFILE`  | Input file containing a list of names, one per line |
| `-N NAME`    | A single name to generate usernames for (enclosed in quotes) |
| `-o OUTFILE` | Output file to write generated usernames to (default: `usernames.txt`) |

`-i` and `-N` are mutually exclusive; exactly one is required.

## Examples

```bash
python username.py -i names.txt -o usernames.txt
python username.py -N "John Michael Smith"
```
