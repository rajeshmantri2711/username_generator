import argparse


def build_usernames(first, last, middle=None):
    first, last = first.lower(), last.lower()
    variants = {
        f"{first}.{last}", f"{first}{last}", f"{first[0]}.{last}",
        f"{first[0]}{last}", f"{first}.{last[0]}", f"{first}_{last}",
        first, last,
    }
    if middle:
        middle = middle.lower()
        variants |= {
            f"{first}{middle[0]}.{last}", f"{first}{middle[0]}{last}",
            f"{first[0]}{middle[0]}{last}", f"{first[0]}{middle[0]}.{last}",
            f"{first[0]}.{middle[0]}.{last}", f"{first}.{middle[0]}.{last[0]}",
            f"{first}_{middle[0]}_{last}",
        }
    return variants


def main(infile='names.txt', name=None, outfile='usernames.txt'):
    if infile:
        try:
            with open(infile, 'r', encoding='utf-8') as fio:
                starting_names = [l.strip() for l in fio if l.strip()]
        except FileNotFoundError:
            print(f"input file '{infile}' does not exist")
            return
    else:
        starting_names = [name]

    all_names = set()
    for l in starting_names:
        parts = l.split()
        if not parts:
            continue
        if len(parts) > 3:
            print(f"skipping '{l}': mangling more than first/middle/last unsupported")
            continue
        first, last = parts[0], parts[-1]
        middle = parts[1] if len(parts) == 3 else None
        all_names |= build_usernames(first, last, middle)

    result = sorted(all_names)
    if outfile:
        with open(outfile, 'w', encoding='utf-8') as fio:
            fio.write('\n'.join(result) + '\n')
        print(f"wrote {len(result)} usernames to '{outfile}'")
    else:
        print('\n'.join(result))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate usernames from first and last names"
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        '-i', metavar='INFILE',
        help="input file containing a list of names (one per line)"
    )
    group.add_argument(
        '-N', metavar='NAME',
        help="a single name to generate usernames for (enclosed in quotes)"
    )
    parser.add_argument(
        '-o', metavar='OUTFILE', default='usernames.txt',
        help="output file to write generated usernames to (default: usernames.txt)"
    )
    args = parser.parse_args()
    main(infile=args.i, outfile=args.o, name=args.N)
