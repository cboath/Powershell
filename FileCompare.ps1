cls
 
$SourceDocs = Get-ChildItem -recurse –Path C:\Sandbox\Folder1 | foreach  {Get-FileHash –Path $_.FullName}
 
$DestDocs = Get-ChildItem -recurse –Path C:\Sandbox\Folder2 | foreach  {Get-FileHash –Path $_.FullName}
 
(Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru).Path