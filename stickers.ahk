#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; dependencies
global PATH_NIR_CMD := "" ; path ending in nircmd.exe
global PATH_IMAGE_MAGICK := "" ; path ending in magick.exe

; config
global PATH_STICKERS := A_WorkingDir . "\stickers\"
global STICKER_PREFIX := "!"
global STICKER_HEIGHT := 128


SendSticker(path, emoji)
{
	cacheDir := A_WorkingDir . "\.sticker_cache"
	if !FileExist(cacheDir)
		FileCreateDir, % cacheDir

	cachePath := cacheDir . "\" . emoji . ".png"
	if !FileExist(cachePath)
		runwait, "%PATH_IMAGE_MAGICK%" "%path%" -resize "x%STICKER_HEIGHT%>" "%cachePath%"

	runwait, "%PATH_NIR_CMD%" clipboard copyimage "%cachePath%"
	send, ^v
}

Loop, Files, %PATH_STICKERS%\*.png
{
	SplitPath, A_LoopFileLongPath, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	Hotstring(":*?:" . STICKER_PREFIX . OutNameNoExt, Func("SendSticker").Bind(A_LoopFileLongPath, OutNameNoExt), "On")
}
