# Hi this is kimmy and you are hopefully reading this before running it.
# If you ran it first, it's totally harmless--but you didn't know that!
# Don't pipe things from the internet directly to iex.
# I don't care which vendors/projects tell you to. Just don't.
# (Looking at you, Chocolatey and Scoop!!)
# Fun fact: unlike curl | bash, irm | iex doesn't even get its own process.
# It runs right inside YOUR session, with YOUR variables, functions, modules,
# and tokens. Sleep well!
# This was dreamed up and created on a single lunch break so I might make it
# better at some point if I feel like it--or make it malicious. ↶(*｀∇´)oΨ
# Here's the code if you want to see it: https://github.com/kimmydotzip/kimmy.sh
# Find me on BlueSky (@kimmy.zip) or the stupid platform (@kimmydotzip)
# Have a nice day!
#
# Usage: .\kimmy.ps1 [-x]
#    or: & ([scriptblock]::Create((irm <url>))) -x    # plain iex can't take args

# long name so an iex'd param block doesn't stomp on your $x. -x still works.
param([Alias('x')][switch]$KimmyNoError)

# everything lives in a scriptblock so I don't litter your session with
# variables. you're welcome. (a malicious version wouldn't be this polite.)
& {
    $no_error  = $KimmyNoError.IsPresent
    $onWindows = ($PSVersionTable.PSEdition -eq 'Desktop') -or $IsWindows
    $root      = if ($onWindows) { "$env:SystemDrive\" } else { '/' }
    $cmd       = "Remove-Item $root -Recurse -Force"

    # 5.1 errors are a whole paragraph; 7+ (ConciseView) are one line.
    # match whichever flavor of panic you're used to.
    $verboseErrors = $ErrorView -eq 'NormalView'

    # 5.1 paints errors in your console's error colors (red on black, usually)
    $errColors = @{ ForegroundColor = 'Red' }
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        try {
            $fg = $Host.PrivateData.ErrorForegroundColor
            $bg = $Host.PrivateData.ErrorBackgroundColor
            if ($fg -is [ConsoleColor]) { $errColors.ForegroundColor = $fg }
            if ($bg -is [ConsoleColor]) { $errColors.BackgroundColor = $bg }
        } catch {}
    }

    function Write-FakeError([string]$Path, [string]$Kind = 'Denied', [switch]$Dir) {
        $type = if ($Dir) { 'DirectoryInfo' } else { 'FileInfo' }
        switch ($Kind) {
            'InUse' {
                $msg = "The process cannot access the file '$Path' because it is being used by another process."
                $cat = 'WriteError'; $ex = 'IOException'; $fqid = 'RemoveFileSystemItemIOError'
            }
            'Busy' {
                $msg = "Device or resource busy : '$Path'"
                $cat = 'WriteError'; $ex = 'IOException'; $fqid = 'RemoveFileSystemItemIOError'
            }
            default {
                $msg = "Access to the path '$Path' is denied."
                $cat = 'PermissionDenied'; $ex = 'UnauthorizedAccessException'; $fqid = 'RemoveFileSystemItemUnAuthorizedAccess'
            }
        }
        if ($Dir) { $msg = 'Cannot remove item {0}: {1}' -f $Path, $msg }

        if ($verboseErrors) {
            $lines = @(
                "Remove-Item : $msg"
                'At line:1 char:1'
                "+ $cmd"
                '+ ' + ('~' * $cmd.Length)
                '    + CategoryInfo          : {0}: ({1}:{2}) [Remove-Item], {3}' -f $cat, $Path, $type, $ex
                '    + FullyQualifiedErrorId : {0},Microsoft.PowerShell.Commands.RemoveItemCommand' -f $fqid
            )
            Write-Host ($lines -join "`n") @errColors
            Write-Host ' '
        } else {
            Write-Host "Remove-Item: $msg" @errColors
        }
    }

    # bash can't see $PS1 from a subshell, so the bash version needs a Neat Trick™.
    # we don't. iex runs in your session, so we can just... call your prompt.
    # think about that for a second.
    $prompt = try { (& prompt) -join '' } catch { $null }
    if (-not $prompt) { $prompt = "PS $($PWD.Path)> " }

    # scary stuff! don't accidentally a word here
    # (colored like PSReadLine would, because details matter)
    Write-Host $prompt -NoNewline
    Write-Host 'Remove-Item' -ForegroundColor Yellow -NoNewline
    Write-Host " $root" -NoNewline
    Write-Host ' -Recurse -Force' -ForegroundColor DarkGray

    # idk, feels right
    Start-Sleep -Milliseconds 250

    if ($onWindows) {
        # the usual survivors of a Windows oopsie
        $d = $env:SystemDrive
        Write-FakeError ($d + '\$Recycle.Bin\S-1-5-18') -Dir
        Write-FakeError "$d\DumpStack.log.tmp" InUse
        Write-FakeError "$d\hiberfil.sys" InUse
        Write-FakeError "$d\pagefile.sys" InUse
        Write-FakeError "$d\swapfile.sys" InUse
        Write-FakeError "$d\System Volume Information" -Dir
        Write-FakeError "$d\Windows\System32\config\SAM"
        Write-FakeError "$d\Windows\System32\config\SECURITY"
        Write-FakeError "$d\Windows\System32\config\SYSTEM"
    } else {
        # took this from a real-world oopsie (not mine)
        Write-FakeError '/boot/grub' Busy -Dir
        Write-FakeError '/dev/mqueue' Busy -Dir
        Write-FakeError '/dev/hugepages' Busy -Dir
        Write-FakeError '/dev/shm' Busy -Dir
        Write-FakeError '/dev/pts/3'
        Write-FakeError '/dev/pts/2'
        Write-FakeError '/dev/pts/1'
        Write-FakeError '/dev/pts/0'
        Write-FakeError '/dev/pts/ptmx'
        Write-FakeError '/etc/exports.d' -Dir
    }

    # you get a full second to think about what you've done ಠ_ಠ
    Start-Sleep -Seconds 1

    # get some real stuffs
    if ($onWindows) {
        # every DLL this very PowerShell process has loaded. they are, in fact, in use.
        $list = (Get-Process -Id $PID).Modules.FileName | Sort-Object -Unique
        foreach ($file in $list) { Write-FakeError $file InUse }
    } else {
        $list = (Get-ChildItem /proc/sys -File -Recurse -Depth 3 -ErrorAction SilentlyContinue).FullName
        foreach ($file in $list) { Write-FakeError $file }
    }

    # computers are slower than this
    Start-Sleep -Milliseconds 250

    # more real stuffs
    if ($onWindows) {
        $list = (Get-ChildItem "$env:SystemRoot\System32" -File -ErrorAction SilentlyContinue).FullName
    } else {
        $list = (Get-ChildItem /sys -File -Recurse -Depth 2 -ErrorAction SilentlyContinue).FullName
    }
    foreach ($file in $list) { Write-FakeError $file }

    # if you haven't ctrl^c by now... I guess you get to see it end. ¯\(°_o)/¯
    Start-Sleep -Seconds 5

    # letting this run is a fail, but sometimes I need it to not error, for _reasons_
    $code = if ($no_error) { 0 } else { 1 }

    # careful: `exit` under iex closes your whole shell, and I'm not *that* mean. yet.
    if ($PSCommandPath) { exit $code }
    $global:LASTEXITCODE = $code
}