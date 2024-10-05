function xdg-open
    set regex 'https?://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    if string match -r $regex $argv[1]
        winfirefox $argv[1]
    else
        wslview $argv[1] >/dev/null
    end
end
