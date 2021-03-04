############################################################################
### Author:Rahul Jain                                                    ###
### Script Purpose :Shell script to Archive log files                    ###
### Script Name:File_System_Clean_Up_Log_Archival_Win.ps1                ###
### OS Supports: Windows                                                 ###
### Version :1.0                                                         ###
############################################################################


### Remove-Item –path C:\Temp\* –recurse

$returnvalue = 0
$Temp = $env:TEMP
$ExtFoundlist = "$Temp\ExtFound.txt"

$li=gci \ -Recurse *.abc | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-1))} 2>&1 | out-null
Foreach ($i in $li)
{
$file1 = $i.FullName
$fullPath=$i.FullName
$zipFile="$fullPath.zip"
$zipFile2Path = $zipFile

Add-Type -Assembly 'System.IO.Compression.FileSystem'
$compressionLevel = [System.IO.Compression.CompressionLevel]::Fastest #Fastest, NoCompression, Optimal

$zip = [System.IO.Compression.ZipFile]::Open($zipFile2Path, 'update')
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file1, (Split-Path $file1 -Leaf), $compressionLevel)
$zip.Dispose()

If (((Get-Item $file1).length/1KB) -gt ((Get-Item $zipFile2Path).length/1KB))
{
    $returnvalue = "$file1-success"
}
else {
    $returnvalue = "$file1-fail"
}
write-output $returnvalue | Out-File $ExtFoundlist  -Append
}
cat $ExtFoundlist  | findstr /c:fail

	if ( $? -eq $false )
{
	$code=0
}
	else
   {
	$code=1
}
write-output $code

cat $ExtFoundlist

Remove-Item $ExtFoundlist
