Brightmode
==========
Brightmode is a simple Bash script that lets you set two brightness modes for your monitors: Day and Night, using the ``ddcutil``. It’s lightweight, easy to use, and allows quick switching between preset brightness levels.

<br>

## Requirements
You need [ddcutil](https://github.com/rockowitz/ddcutil) installed for Brightmode to work.

#### Ubuntu/Debian
```
apt install ddcutil
```

#### Fedora/RHEL
```
dnf install ddcutil
```

#### Arch Linux
```
pacman -S ddcutil
```

#### openSUSE
```
zypper install ddcutil
```

<br>

## Setup

``ddcutil`` requires root permissions to access your monitors. To avoid running Brightmode as root every time, we’ll give your user the proper permissions via an ``i2c`` group and a ``udev`` rule.

#### 1. Create the i2c group (if it doesn’t exist):
```
sudo groupadd i2c
```

#### 2. Add your user to the group:
```
sudo usermod -aG i2c $USER
```

#### 3. Create the udev rule:
```
sudo nano /etc/udev/rules.d/45-ddcutil-i2c.rules
```

#### 4. Add this content to the file:
```
KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
```

#### 5. Reload and apply the rules:
```
sudo udevadm control --reload
sudo udevadm trigger
```

#### 6. Log out and log back in

This ensures your user is part of the ``i2c`` group. After this, you can run Brightmode without needing root privileges or entering your password each time.

<br>

## Making Brightmode globally available

To run the script from any directory, move it to a folder in your ``$PATH``, for example:

```
sudo mv ./brightmode.sh /usr/local/bin/brightmode
sudo chmod +x /usr/local/bin/brightmode
```

<br>

## Usage

Using Brightmode is ridiculously simple:

#### Day mode (increase screen brightness):
```
brightmode day
```

#### Night mode (decrease screen brightness):
```
brightmode night
```

<br>

## Configuring brightness levels
Is the default brightness not quite what you want? Don’t worry. Open the ``brightmode`` file (should be in ``/usr/local/bin/``) in a text editor **(you’ll need root permissions to save changes)**.

Lines ``9`` and ``10`` define the brightness for each mode, where 0 is completely dark and 100 is maximum brightness. Adjust these values as desired and save the file.

<br>

## Creative mode
Need more brightness modes? Want to change other settings like contrast or gamma? You can get creative and use ``brightmode`` as a **template** to add more options. The sky’s the limit!

Since ``ddcutil`` allows many possibilities (seriously, Sanford Rockowitz is a genius!), we’ll focus on brightness profiles. Open ``/usr/local/bin/brightmode`` and let’s add a new profile called ``BRIGHTNESS_AFTERNOON`` (intermediate between day and night):

#### 1. Add a new brightness variable
Below line ``10`` (``BRIGHTNESS_NIGHT=10``) add your new profile:

```
# Configure the brightness values for each mode
BRIGHTNESS_DAY=50
BRIGHTNESS_NIGHT=10
BRIGHTNESS_AFTERNOON=30
#--------------------
```

#### 2. Update the help message
Change the usage line:

```
echo "Usage: brightmode <day|night>"
```

To:

```
echo "Usage: brightmode <day|night|afternoon>"
```

#### 3. Update the mode check
Add a condition for your new profile:

```
if [ $1 == "day" ]; then
    BRIGHT=$BRIGHTNESS_DAY
elif [ $1 == "night" ]; then
    BRIGHT=$BRIGHTNESS_NIGHT
elif [ $1 == "afternoon" ]; then
    BRIGHT=$BRIGHTNESS_AFTERNOON
else
    echo -e "${RED}Error: mode \"$1\" is not allowed! Options: \"day\", \"night\" or \"afternoon\"${NC}"
    exit 1
fi
```

What happens if we add many brightness profiles? That ``if`` is gonna be a mess, but I’ll let you sort it out. 😉

After saving, you can run your new profile:

```
brightmode afternoon
```

<br>

## Reporting issues and improvements
Honestly, it’s hard to imagine this script causing any issues, but you can report bugs via the [Issue Tracker](https://github.com/dprietob/brightmode/issues). If you can think of any improvements (there is plenty of room for them) or anything new that this script could do, that is also welcome 🤓

<br>

<small>Seriously, this *README* is longer than the script itself…</small>