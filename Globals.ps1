#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory


function Refresh-Listbox
{
	$connlist.Items.Clear()
	$global:savedconnections = Get-ChildItem $savelocation -Filter *.tigervnc | select BaseName, FullName
	If ($savedconnections -ne $null)
	{
		foreach ($name in $savedconnections)
		{
			Update-Listbox $connlist $name.BaseName -Append
		}
	}
	Else
	{
		Load-VNC ($wd + "\" + "Defaults.dat")
	}
}

function Save-VNC ($status)
{
	If ($status -eq "New")
	{
		$con = @()
		$item = New-Object PSObject
		$item | Add-Member -Type NoteProperty -Name 'ServerName' -Value $newip.Text
		$hostname = $newhost.Text
	}
	Else
	{
		$con = @()
		$item = New-Object PSObject
		If ($editip.Checked -eq $true -and $newsavip.Text -ne $null)
		{
			$item | Add-Member -Type NoteProperty -Name 'ServerName' -Value $newsavip.Text
			$hostname = $savname.Text
		}
		If ($editname.Checked -eq $true -and $newsavname.Text -ne $null)
		{
			$item | Add-Member -Type NoteProperty -Name 'ServerName' -Value $savip.Text
			$hostname = $newsavname.Text
		}
		If ($editname.Checked -eq $false -and $editip.Checked -eq $false)
		{
			$item | Add-Member -Type NoteProperty -Name 'ServerName' -Value $savip.Text
			$hostname = $savname.Text
		}
	}
	$item | Add-Member -Type NoteProperty -Name 'X509CA' -Value $capat.Text
	$item | Add-Member -Type NoteProperty -Name 'X509CRL' -Value $crlpat.Text
	$sec = $null
	If ($noencrypt.Checked -eq $true -and $noauth.Checked -eq $true)
	{
		$sec += "None,Plain,"
		If ($useandpass.Checked -eq $true)
		{
			$sec += "VNCAuth,"	
		}
	}
	If ($standardvnc.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSVnc,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509Vnc,"
		}
	}
	If ($useandpass.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSPlain,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509Plain,"
		}
	}
	If ($noauth.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSNone,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509None,"
		}
	}
	$item | Add-Member -Type NoteProperty -Name 'SecurityTypes' -Value ($sec.Substring(0, ($sec.Length - 1)))
	If ($showdotbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'DotWhenNoCursor' -Value "1"
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'DotWhenNoCursor' -Value "0"
	}
	If ($autocomp.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'AutoSelect' -Value "1"
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'AutoSelect' -Value "0"
		If ($fulcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'FullColor' -Value "1"
		}
		else
		{
			$item | Add-Member -Type NoteProperty -Name 'FullColor' -Value "0"
		}
		If ($medcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "2"
		}
		elseif ($lowcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "1"
		}
		elseif ($vlowcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "0"
		}
		If ($prefenctight.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Tight"
		}
		elseIf ($prefenczrle.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "ZRLE"
		}
		elseif ($prefenchextile.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Hextile"
		}
		elseif ($prefencraw.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Raw"
		}
		If ($jpgcomp.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'NoJPEG' -Value "0"
			$item | Add-Member -Type NoteProperty -Name 'QualityLevel' -Value $jpgcomplvl.Text
		}
		Else
		{
			$item | Add-Member -Type NoteProperty -Name 'NoJPEG' -Value "1"
		}
	}
	If ($cuscomp.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'CustomCompressLevel' -Value "1"
		$item | Add-Member -Type NoteProperty -Name 'CompressLevel' -Value $cuscomplvl.Text
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'CustomCompressLevel' -Value "0"
	}	
	If ($fullscreenmode.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreen' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreen' -Value "0"
	}
	If ($fulscrallmon.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreenAllMonitors' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreenAllMonitors' -Value "0"
	}
	If ($resizesessbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'DesktopSize' -Value ($reswidth.Text + "x" + $resheight.Text)
	}
	If ($reslocwin.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'RemoteResize' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'RemoteResize' -Value "0"
	}
	If ($viewonly.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'ViewOnly' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'ViewOnly' -Value "0"
	}
	If ($sharedbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'Shared' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'Shared' -Value "0"
	}
	If ($acptclpbrd.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'AcceptClipboard' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'AcceptClipboard' -Value "0"
	}
	If ($sndclpbrd.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'SendClipboard' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'SendClipboard' -Value "0"
	}
	If ($passkeys.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullscreenSystemKeys' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullscreenSystemKeys' -Value "0"
	}
	$item | Add-Member -Type NoteProperty -Name 'MenuKey' -Value $menukey.Text
	$con += $item
	$head = "TigerVNC Configuration file Version 1.0



"
	$nl = [Environment]::NewLine
	$con | Get-Member -type noteproperty | foreach-object {
		$name=$_.Name;
		$value=$con."$($_.Name)"
		$head += "$name=$value"
		$head += $nl
	}
	$head | Out-File ($savelocation + "\" + $hostname + ".tigervnc")
}
#region Control Helper Functions
function Update-ListBox
{
<#
	.SYNOPSIS
		This functions helps you load items into a ListBox or CheckedListBox.
	
	.DESCRIPTION
		Use this function to dynamically load items into the ListBox control.
	
	.PARAMETER ListBox
		The ListBox control you want to add items to.
	
	.PARAMETER Items
		The object or objects you wish to load into the ListBox's Items collection.
	
	.PARAMETER DisplayMember
		Indicates the property to display for the items in this control.
	
	.PARAMETER Append
		Adds the item(s) to the ListBox without clearing the Items collection.
	
	.EXAMPLE
		Update-ListBox $ListBox1 "Red", "White", "Blue"
	
	.EXAMPLE
		Update-ListBox $listBox1 "Red" -Append
		Update-ListBox $listBox1 "White" -Append
		Update-ListBox $listBox1 "Blue" -Append
	
	.EXAMPLE
		Update-ListBox $listBox1 (Get-Process) "ProcessName"
	
	.NOTES
		Additional information about the function.
#>
	
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNull()]
		[System.Windows.Forms.ListBox]$ListBox,
		[Parameter(Mandatory = $true)]
		[ValidateNotNull()]
		$Items,
		[Parameter(Mandatory = $false)]
		[string]$DisplayMember,
		[switch]$Append
	)
	
	if (-not $Append)
	{
		$listBox.Items.Clear()
	}
	
	if ($Items -is [System.Windows.Forms.ListBox+ObjectCollection] -or $Items -is [System.Collections.ICollection])
	{
		$listBox.Items.AddRange($Items)
	}
	elseif ($Items -is [System.Collections.IEnumerable])
	{
		$listBox.BeginUpdate()
		foreach ($obj in $Items)
		{
			$listBox.Items.Add($obj)
		}
		$listBox.EndUpdate()
	}
	else
	{
		$listBox.Items.Add($Items)
	}
	
	$listBox.DisplayMember = $DisplayMember
}
#endregion


function Load-VNC ($file)
{
	$data = Get-Content $file
	
	foreach ($thing in $data)
	{
		$line = $thing.Split("=")
		If ($line[0] -eq "ServerName")
		{
			$savip.Text = $line[1]
		}
		Elseif ($line[0] -eq "X509CA")
		{
			$capat.Text = $line[1]
		}
		Elseif ($line[0] -eq "X509CRL")
		{
			$crlpat.Text = $line[1]
		}
		Elseif ($line[0] -eq "SecurityTypes")
		{
			$types = $line[1].Split(",")
			Foreach ($type in $types)
			{
				If ($type -eq "None")
				{
					$noauth.Checked = $true
					$noencrypt.Checked = $true
				}
				Elseif ($type -eq "VncAuth")
				{
					$useandpass.Checked = $true
				}
				Elseif ($type -eq "Plain")
				{
					$standardvnc.Checked = $false
				}
				Elseif ($type -eq "TLSNone")
				{
					$noauth.Checked = $true
					$tlsanon.Checked = $true
				}
				Elseif ($type -eq "TLSVnc")
				{
					$standardvnc.Checked = $true
					$tlsanon.Checked = $true
				}
				Elseif ($type -eq "TLSPlain")
				{
					$tlsanon.Checked = $true
					$useandpass.Checked = $true
				}
				Elseif ($type -eq "X509None")
				{
					$tlswithcerts.Checked = $true
					$noauth.Checked = $true
				}
				Elseif ($type -eq "X509Vnc")
				{
					$tlswithcerts.Checked = $true
					$standardvnc.Checked = $true
				}
				Elseif ($type -eq "X509Plain")
				{
					$tlswithcerts.Checked = $true
					$useandpass.Checked = $true
				}
			}
		}
		Elseif ($line[0] -eq "DotWhenNoCursor")
		{
			If ($line[1] -eq "1")
			{
				$showdotbox.Checked = $true
			}
			else { $showdotbox.Checked = $false }
		}
		elseif ($line[0] -eq "AutoSelect")
		{
			If ($line[1] -eq "1")
			{
				$autocomp.Checked = $true
			}
			Else { $uaotcomp.Checked = $false }
		}
		elseif ($line[0] -eq "FullColor")
		{
			If ($line[1] -eq "1")
			{
				$fulcol.Checked = $true
			}
			Else { $fulcol.Checked = $false }
		}
		elseif ($line[0] -eq "LowColorLevel")
		{
			If ($line[1] -eq "2")
			{
				$medcol.Checked = $true
			}
			elseif ($line[1] -eq "1")
			{
				$lowcol.Checked = $true
			}
			elseif ($line[1] -eq "0")
			{
				$vlowcol.Checked = $true
			}
		}
		elseif ($line[0] -eq "PreferredEncoding")
		{
			If ($line[1] -eq "Tight")
			{
				$prefenctight.Checked = $true
			}
			elseif ($line[1] -eq "ZRLE")
			{
				$prefenczrle.Checked = $true
			}
			elseif ($line[1] -eq "Hextile")
			{
				$prefenchextile.Checked = $true
			}
			elseif ($line[1] -eq "Raw")
			{
				$prefencraw.Checked = $true
			}
		}
		elseif ($line[0] -eq "CustomCompressLevel")
		{
			If ($line[1] -eq "1")
			{
				$cuscomp.Checked = $true
			}
			else { $cuscomp.Checked = $false }
		}
		elseif ($line[0] -eq "CompressLevel")
		{
			$cuscomplvl.Text = $line[1]
		}
		elseif ($line[0] -eq "NoJPEG")
		{
			If ($line[1] -eq "1")
			{
				$jpgcomp.Checked = $true
			}
			else { $jpgcomp.Checked = $false }
		}
		elseif ($line[0] -eq "QualityLevel")
		{
			$jpgcomplvl.Text = $line[1]
		}
		elseif ($line[0] -eq "FullScreen")
		{
			If ($line[1] -eq "1")
			{
				$fullscreenmode.Checked = $true
			}
			else { $fullscreenmode.Checked = $false }
		}
		elseif ($line[0] -eq "FullScreenAllMonitors")
		{
			If ($line[1] -eq "1")
			{
				$fulscrallmon.Checked = $true
			}
			else { $fulscrallmon.Checked = $false }
		}
		elseif ($line[0] -eq "DesktopSize")
		{
			$dt = $line[1].Split("x")
			$resizesessbox.Checked = $true
			$reswidth.Text = $dt[0]
			$resheight.Text = $dt[1]
		}
		elseif ($line[0] -eq "RemoteSize")
		{
			If ($line[1] -eq "1")
			{
				$reslocwin.Checked = $true
			}
			else { $reslocwin.Checked = $false }
		}
		elseif ($line[0] -eq "ViewOnly")
		{
			If ($line[1] -eq "1")
			{
				$viewonly.Checked = $true
			}
			else { $viewonly.Checked = $false }
		}
		elseif ($line[0] -eq "Shared")
		{
			If ($line[1] -eq "1")
			{
				$sharedbox.Checked = $true
			}
			else { $sharedbox.Checked = $false }
		}
		elseif ($line[0] -eq "AcceptClipboard")
		{
			If ($line[1] -eq "1")
			{
				$acptclpbrd.Checked = $true
			}
			else { $acptclpbrd.Checked = $false }
		}
		elseif ($line[0] -eq "SendClipboard")
		{
			If ($line[1] -eq "1")
			{
				$sndclpbrd.Checked = $true
			}
			else { $sndclpbrd.Checked = $false }
		}
		elseif ($line[0] -eq "FullscreenSystemKeys")
		{
			If ($line[1] -eq "1")
			{
				$passkeys.Checked = $true
			}
			else { $passkeys.Checked = $false }
		}
		elseif ($line[0] -eq "MenuKey")
		{
			$menukey.Text = $line[1]
		}
	}
	
}


function Init-Connection ($status)
{
	If ($status -eq "New")
	{
		$targetip =  $newip.Text
	}
	Else
	{
		If ($editip.Checked -eq $true -and $newsavip.Text -ne $null)
		{
			$targetip =  $newsavip.Text
		}
		Else
		{
			$targetip = $savip.Text
		}
	}
	$con = @()
	$item = New-Object PSObject
	$item | Add-Member -Type NoteProperty -Name 'X509CA' -Value $capat.Text
	$item | Add-Member -Type NoteProperty -Name 'X509CRL' -Value $crlpat.Text
	$sec = $null
	If ($noencrypt.Checked -eq $true -and $noauth.Checked -eq $true)
	{
		$sec += "None,Plain,"
		If ($useandpass.Checked -eq $true)
		{
			$sec += "VNCAuth,"
		}
	}
	If ($standardvnc.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSVnc,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509Vnc,"
		}
	}
	If ($useandpass.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSPlain,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509Plain,"
		}
	}
	If ($noauth.Checked -eq $true)
	{
		If ($tlsanon.Checked -eq $true)
		{
			$sec += "TLSNone,"
		}
		If ($tlswithcerts.Checked -eq $true)
		{
			$sec += "X509None,"
		}
	}
	$item | Add-Member -Type NoteProperty -Name 'SecurityTypes' -Value ($sec.Substring(0,($sec.Length - 1)))
	If ($showdotbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'DotWhenNoCursor' -Value "1"
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'DotWhenNoCursor' -Value "0"
	}
	If ($autocomp.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'AutoSelect' -Value "1"
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'AutoSelect' -Value "0"
		If ($fulcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'FullColor' -Value "1"
		}
		else
		{
			$item | Add-Member -Type NoteProperty -Name 'FullColor' -Value "0"
		}
		If ($medcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "2"
		}
		elseif ($lowcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "1"
		}
		elseif ($vlowcol.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'LowColorLevel' -Value "0"
		}
		If ($prefenctight.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Tight"
		}
		elseIf ($prefenczrle.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "ZRLE"
		}
		elseif ($prefenchextile.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Hextile"
		}
		elseif ($prefencraw.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'PreferredEncoding' -Value "Raw"
		}
		If ($jpgcomp.Checked -eq $true)
		{
			$item | Add-Member -Type NoteProperty -Name 'NoJPEG' -Value "0"
			$item | Add-Member -Type NoteProperty -Name 'QualityLevel' -Value $jpgcomplvl.Text
		}
		Else
		{
			$item | Add-Member -Type NoteProperty -Name 'NoJPEG' -Value "1"
		}
	}
	If ($cuscomp.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'CustomCompressLevel' -Value "1"
		$item | Add-Member -Type NoteProperty -Name 'CompressLevel' -Value $cuscomplvl.Text
	}
	Else
	{
		$item | Add-Member -Type NoteProperty -Name 'CustomCompressLevel' -Value "0"
	}
	If ($fullscreenmode.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreen' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreen' -Value "0"
	}
	If ($fulscrallmon.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreenAllMonitors' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullScreenAllMonitors' -Value "0"
	}
	If ($resizesessbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'DesktopSize' -Value ($reswidth.Text + "x" + $resheight.Text)
	}
	If ($reslocwin.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'RemoteResize' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'RemoteResize' -Value "0"
	}
	If ($viewonly.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'ViewOnly' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'ViewOnly' -Value "0"
	}
	If ($sharedbox.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'Shared' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'Shared' -Value "0"
	}
	If ($acptclpbrd.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'AcceptClipboard' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'AcceptClipboard' -Value "0"
	}
	If ($sndclpbrd.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'SendClipboard' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'SendClipboard' -Value "0"
	}
	If ($passkeys.Checked -eq $true)
	{
		$item | Add-Member -Type NoteProperty -Name 'FullscreenSystemKeys' -Value "1"
	}
	else
	{
		$item | Add-Member -Type NoteProperty -Name 'FullscreenSystemKeys' -Value "0"
	}
	$item | Add-Member -Type NoteProperty -Name 'MenuKey' -Value $menukey.Text
	$con += $item
	$con | Get-Member -type noteproperty | foreach-object {
		$name = $_.Name;
		$value = $con."$($_.Name)"
		$head += "--$name=$value "
	}
	$head += (" " + $targetip)
	Start-Process ($exelocation + "\" + "vncviewer.exe") -ArgumentList $head
}