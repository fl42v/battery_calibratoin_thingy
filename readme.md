# battery_calibratoin_thingy

After replacing the cells in a laptop's battery, its bms needs a few charge-discharge cycles
to pick up the new capacity. This script automates this task while monitoring for overcharge and overdischarge,
as my bms decided overcharging the cells up to 4.3 volts would be a nice revenge for making it work after early retirement.

# dependencies

- [amber](github.com/amber-lang/amber) (optional)
- [gum](github.com/charmbracelet/gum) (prompts and stuff)
- bc (used by amber to make math work)
- [stress-ng](https://github.com/ColinIanKing/stress-ng) (speeds up discharge cycles a bit)

# usage

It's more or less interactive, so should be pretty understandable. Run it with either `sudo amber batcal.ab` or `sudo ./batcal.sh` (which is the same but compiled. Probably should put it into releases but whatever)
