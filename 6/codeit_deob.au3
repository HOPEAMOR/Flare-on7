#region
	#AutoIt3Wrapper_UseUpx=y
#endregion
Global Const $STR_NOCASESENSE = 0
Global Const $STR_CASESENSE = 1
Global Const $STR_NOCASESENSEBASIC = 2
Global Const $STR_STRIPLEADING = 1
Global Const $STR_STRIPTRAILING = 2
Global Const $STR_STRIPSPACES = 4
Global Const $STR_STRIPALL = 8
Global Const $STR_CHRSPLIT = 0
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $STR_REGEXPMATCH = 0
Global Const $STR_REGEXPARRAYMATCH = 1
Global Const $STR_REGEXPARRAYFULLMATCH = 2
Global Const $STR_REGEXPARRAYGLOBALMATCH = 3
Global Const $STR_REGEXPARRAYGLOBALFULLMATCH = 4
Global Const $STR_ENDISSTART = 0
Global Const $STR_ENDNOTSTART = 1
Global Const $SB_ANSI = 1
Global Const $SB_UTF16LE = 2
Global Const $SB_UTF16BE = 3
Global Const $SB_UTF8 = 4
Global Const $SE_UTF16 = 0
Global Const $SE_ANSI = 1
Global Const $SE_UTF8 = 2
Global Const $STR_UTF16 = 0
Global Const $STR_UCS2 = 1
Func _HexToString($SHEX)
	If Not (StringLeft($SHEX, 2) == "0x") Then $SHEX = "0x" & $SHEX
	Return BinaryToString($SHEX, $SB_UTF8)
EndFunc
Func _StringBetween($SSTRING, $SSTART, $SEND, $IMODE = $STR_ENDISSTART, $BCASE = False)
	$SSTART = $SSTART ? "\Q" & $SSTART & "\E" : "\A"
	If $IMODE <> $STR_ENDNOTSTART Then $IMODE = $STR_ENDISSTART
	If $IMODE = $STR_ENDISSTART Then
		$SEND = $SEND ? "(?=\Q" & $SEND & "\E)" : "\z"
	Else
		$SEND = $SEND ? "\Q" & $SEND & "\E" : "\z"
	EndIf
	If $BCASE = Default Then
		$BCASE = False
	EndIf
	Local $ARETURN = StringRegExp($SSTRING, "(?s" & (Not $BCASE ? "i" : "") & ")" & $SSTART & "(.*?)" & $SEND, $STR_REGEXPARRAYGLOBALMATCH)
	If @error Then Return SetError(1, 0, 0)
	Return $ARETURN
EndFunc
Func _StringExplode($SSTRING, $SDELIMITER, $ILIMIT = 0)
	If $ILIMIT = Default Then $ILIMIT = 0
	If $ILIMIT > 0 Then
		Local Const $NULL = Chr(0)
		$SSTRING = StringReplace($SSTRING, $SDELIMITER, $NULL, $ILIMIT)
		$SDELIMITER = $NULL
	ElseIf $ILIMIT < 0 Then
		Local $IINDEX = StringInStr($SSTRING, $SDELIMITER, $STR_NOCASESENSEBASIC, $ILIMIT)
		If $IINDEX Then
			$SSTRING = StringLeft($SSTRING, $IINDEX - 1)
		EndIf
	EndIf
	Return StringSplit($SSTRING, $SDELIMITER, BitOR($STR_ENTIRESPLIT, $STR_NOCOUNT))
EndFunc
Func _StringInsert($SSTRING, $SINSERTION, $IPOSITION)
	Local $ILENGTH = StringLen($SSTRING)
	$IPOSITION = Int($IPOSITION)
	If $IPOSITION < 0 Then $IPOSITION = $ILENGTH + $IPOSITION
	If $ILENGTH < $IPOSITION Or $IPOSITION < 0 Then Return SetError(1, 0, $SSTRING)
	Return StringLeft($SSTRING, $IPOSITION) & $SINSERTION & StringRight($SSTRING, $ILENGTH - $IPOSITION)
EndFunc
Func _StringProper($SSTRING)
	Local $BCAPNEXT = True, $SCHR = "", $SRETURN = ""
	For $I = 1 To StringLen($SSTRING)
		$SCHR = StringMid($SSTRING, $I, 1)
		Select
			Case $BCAPNEXT = True
				If StringRegExp($SCHR, "[a-zA-ZÀ-ÿšœžŸ]") Then
					$SCHR = StringUpper($SCHR)
					$BCAPNEXT = False
				EndIf
			Case Not StringRegExp($SCHR, "[a-zA-ZÀ-ÿšœžŸ]")
				$BCAPNEXT = True
			Case Else
				$SCHR = StringLower($SCHR)
		EndSelect
		$SRETURN &= $SCHR
	Next
	Return $SRETURN
EndFunc
Func _StringRepeat($SSTRING, $IREPEATCOUNT)
	$IREPEATCOUNT = Int($IREPEATCOUNT)
	If $IREPEATCOUNT = 0 Then Return ""
	If StringLen($SSTRING) < 1 Or $IREPEATCOUNT < 0 Then Return SetError(1, 0, "")
	Local $SRESULT = ""
	While $IREPEATCOUNT > 1
		If BitAND($IREPEATCOUNT, 1) Then $SRESULT &= $SSTRING
		$SSTRING &= $SSTRING
		$IREPEATCOUNT = BitShift($IREPEATCOUNT, 1)
	WEnd
	Return $SSTRING & $SRESULT
EndFunc
Func _STRINGTITLECASE($SSTRING)
	Local $BCAPNEXT = True, $SCHR = "", $SRETURN = ""
	For $I = 1 To StringLen($SSTRING)
		$SCHR = StringMid($SSTRING, $I, 1)
		Select
			Case $BCAPNEXT = True
				If StringRegExp($SCHR, "[a-zA-Z\xC0-\xFF0-9]") Then
					$SCHR = StringUpper($SCHR)
					$BCAPNEXT = False
				EndIf
			Case Not StringRegExp($SCHR, "[a-zA-Z\xC0-\xFF'0-9]")
				$BCAPNEXT = True
			Case Else
				$SCHR = StringLower($SCHR)
		EndSelect
		$SRETURN &= $SCHR
	Next
	Return $SRETURN
EndFunc
Func _StringToHex($SSTRING)
	Return Hex(StringToBinary($SSTRING, $SB_UTF8))
EndFunc
#OnAutoItStartRegister "create_os_array"
Global $STRINGS_ARR
Global $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 ")
Global $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $6 = Number(" 6 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $6 = Number(" 6 "), $4 = Number(" 4 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $3 = Number(" 3 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 ")
Global $0 = Number(" 0 "), $1 = Number(" 1 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $7 = Number(" 7 "), $0 = Number(" 0 "), $7 = Number(" 7 "), $0 = Number(" 0 ")
Global $2 = Number(" 2 "), $4 = Number(" 4 "), $3 = Number(" 3 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $4 = Number(" 4 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $6 = Number(" 6 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $5 = Number(" 5 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $0 = Number(" 0 ")
Global $3 = Number(" 3 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 ")
Global $5 = Number(" 5 "), $6 = Number(" 6 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $4 = Number(" 4 "), $3 = Number(" 3 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $4 = Number(" 4 "), $1 = Number(" 1 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $6 = Number(" 6 "), $4 = Number(" 4 "), $2 = Number(" 2 "), $4 = Number(" 4 ")
Global $2 = Number(" 2 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $2 = Number(" 2 "), $4 = Number(" 4 "), $3 = Number(" 3 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $4 = Number(" 4 "), $3 = Number(" 3 "), $4 = Number(" 4 "), $5 = Number(" 5 "), $6 = Number(" 6 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 ")
Global $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $6 = Number(" 6 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $7 = Number(" 7 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $3 = Number(" 3 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 ")
Global $0 = Number(" 0 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $6 = Number(" 6 "), $3 = Number(" 3 "), $0 = Number(" 0 "), $7 = Number(" 7 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 "), $1 = Number(" 1 ")
Global $3 = Number(" 3 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $4 = Number(" 4 "), $0 = Number(" 0 "), $5 = Number(" 5 "), $0 = Number(" 0 "), $6 = Number(" 6 "), $0 = Number(" 0 "), $7 = Number(" 7 "), $0 = Number(" 0 "), $8 = Number(" 8 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $9 = Number(" 9 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 "), $0 = Number(" 0 ")
Global $36 = Number(" 36 "), $39 = Number(" 39 "), $28 = Number(" 28 "), $25 = Number(" 25 "), $26 = Number(" 26 "), $156 = Number(" 156 "), $28 = Number(" 28 "), $25 = Number(" 25 "), $26 = Number(" 26 "), $157 = Number(" 157 "), $138 = Number(" 138 "), $154 = Number(" 154 "), $25 = Number(" 25 "), $36 = Number(" 36 "), $158 = Number(" 158 "), $28 = Number(" 28 "), $39 = Number(" 39 "), $2 = Number(" 2 "), $0 = Number(" 0 "), $1 = Number(" 1 "), $0 = Number(" 0 "), $2 = Number(" 2 "), $3 = Number(" 3 "), $4 = Number(" 4 "), $0 = Number(" 0 ")
Global $150 = Number(" 150 "), $128 = Number(" 128 "), $28 = Number(" 28 "), $25 = Number(" 25 "), $150 = Number(" 150 "), $151 = Number(" 151 "), $28 = Number(" 28 "), $152 = Number(" 152 "), $28 = Number(" 28 "), $150 = Number(" 150 "), $150 = Number(" 150 "), $25 = Number(" 25 "), $28 = Number(" 28 "), $153 = Number(" 153 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $150 = Number(" 150 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $154 = Number(" 154 "), $25 = Number(" 25 "), $26 = Number(" 26 "), $155 = Number(" 155 "), $28 = Number(" 28 "), $39 = Number(" 39 ")
Global $19778 = Number(" 19778 "), $148 = Number(" 148 "), $25 = Number(" 25 "), $28 = Number(" 28 "), $149 = Number(" 149 "), $138 = Number(" 138 "), $22 = Number(" 22 "), $150 = Number(" 150 "), $2147483648 = Number(" 2147483648 "), $150 = Number(" 150 "), $28 = Number(" 28 "), $150 = Number(" 150 "), $150 = Number(" 150 "), $128 = Number(" 128 "), $28 = Number(" 28 "), $25 = Number(" 25 "), $28 = Number(" 28 "), $149 = Number(" 149 "), $138 = Number(" 138 "), $22 = Number(" 22 "), $150 = Number(" 150 "), $1073741824 = Number(" 1073741824 "), $150 = Number(" 150 "), $28 = Number(" 28 "), $150 = Number(" 150 ")
Global $26 = Number(" 26 "), $135 = Number(" 135 "), $136 = Number(" 136 "), $137 = Number(" 137 "), $39 = Number(" 39 "), $138 = Number(" 138 "), $1024 = Number(" 1024 "), $136 = Number(" 136 "), $139 = Number(" 139 "), $39 = Number(" 39 "), $39 = Number(" 39 "), $25 = Number(" 25 "), $30 = Number(" 30 "), $21 = Number(" 21 "), $11 = Number(" 11 "), $140 = Number(" 140 "), $141 = Number(" 141 "), $142 = Number(" 142 "), $143 = Number(" 143 "), $144 = Number(" 144 "), $145 = Number(" 145 "), $146 = Number(" 146 "), $4096 = Number(" 4096 "), $134 = Number(" 134 "), $147 = Number(" 147 ")
Global $26 = Number(" 26 "), $126 = Number(" 126 "), $28 = Number(" 28 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $125 = Number(" 125 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $128 = Number(" 128 "), $25 = Number(" 25 "), $26 = Number(" 26 "), $129 = Number(" 129 "), $39 = Number(" 39 "), $130 = Number(" 130 "), $300 = Number(" 300 "), $131 = Number(" 131 "), $30 = Number(" 30 "), $300 = Number(" 300 "), $132 = Number(" 132 "), $55 = Number(" 55 "), $300 = Number(" 300 "), $300 = Number(" 300 "), $133 = Number(" 133 "), $134 = Number(" 134 "), $13 = Number(" 13 ")
Global $34 = Number(" 34 "), $26 = Number(" 26 "), $37 = Number(" 37 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $32771 = Number(" 32771 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $38 = Number(" 38 "), $28 = Number(" 28 "), $39 = Number(" 39 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $40 = Number(" 40 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $34 = Number(" 34 ")
Global $26 = Number(" 26 "), $125 = Number(" 125 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $126 = Number(" 126 "), $28 = Number(" 28 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $125 = Number(" 125 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $127 = Number(" 127 "), $16 = Number(" 16 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $35 = Number(" 35 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $24 = Number(" 24 "), $36 = Number(" 36 "), $4026531840 = Number(" 4026531840 ")
Global $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $121 = Number(" 121 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $122 = Number(" 122 "), $123 = Number(" 123 "), $10 = Number(" 10 "), $14 = Number(" 14 "), $18 = Number(" 18 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $124 = Number(" 124 "), $28 = Number(" 28 "), $34 = Number(" 34 ")
Global $108 = Number(" 108 "), $109 = Number(" 109 "), $110 = Number(" 110 "), $111 = Number(" 111 "), $112 = Number(" 112 "), $113 = Number(" 113 "), $114 = Number(" 114 "), $115 = Number(" 115 "), $116 = Number(" 116 "), $117 = Number(" 117 "), $118 = Number(" 118 "), $119 = Number(" 119 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $35 = Number(" 35 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $24 = Number(" 24 "), $36 = Number(" 36 "), $4026531840 = Number(" 4026531840 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $120 = Number(" 120 ")
Global $83 = Number(" 83 "), $84 = Number(" 84 "), $85 = Number(" 85 "), $86 = Number(" 86 "), $87 = Number(" 87 "), $88 = Number(" 88 "), $89 = Number(" 89 "), $90 = Number(" 90 "), $91 = Number(" 91 "), $92 = Number(" 92 "), $93 = Number(" 93 "), $94 = Number(" 94 "), $95 = Number(" 95 "), $96 = Number(" 96 "), $97 = Number(" 97 "), $98 = Number(" 98 "), $99 = Number(" 99 "), $100 = Number(" 100 "), $101 = Number(" 101 "), $102 = Number(" 102 "), $103 = Number(" 103 "), $104 = Number(" 104 "), $105 = Number(" 105 "), $106 = Number(" 106 "), $107 = Number(" 107 ")
Global $58 = Number(" 58 "), $59 = Number(" 59 "), $60 = Number(" 60 "), $61 = Number(" 61 "), $62 = Number(" 62 "), $63 = Number(" 63 "), $64 = Number(" 64 "), $65 = Number(" 65 "), $66 = Number(" 66 "), $67 = Number(" 67 "), $68 = Number(" 68 "), $69 = Number(" 69 "), $70 = Number(" 70 "), $71 = Number(" 71 "), $72 = Number(" 72 "), $73 = Number(" 73 "), $74 = Number(" 74 "), $75 = Number(" 75 "), $76 = Number(" 76 "), $77 = Number(" 77 "), $78 = Number(" 78 "), $79 = Number(" 79 "), $80 = Number(" 80 "), $81 = Number(" 81 "), $82 = Number(" 82 ")
Global $26 = Number(" 26 "), $40 = Number(" 40 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $41 = Number(" 41 "), $42 = Number(" 42 "), $43 = Number(" 43 "), $44 = Number(" 44 "), $45 = Number(" 45 "), $46 = Number(" 46 "), $41 = Number(" 41 "), $47 = Number(" 47 "), $48 = Number(" 48 "), $49 = Number(" 49 "), $50 = Number(" 50 "), $51 = Number(" 51 "), $52 = Number(" 52 "), $53 = Number(" 53 "), $54 = Number(" 54 "), $55 = Number(" 55 "), $56 = Number(" 56 "), $57 = Number(" 57 ")
Global $35 = Number(" 35 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $24 = Number(" 24 "), $36 = Number(" 36 "), $4026531840 = Number(" 4026531840 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $37 = Number(" 37 "), $28 = Number(" 28 "), $36 = Number(" 36 "), $32780 = Number(" 32780 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $28 = Number(" 28 "), $34 = Number(" 34 "), $26 = Number(" 26 "), $38 = Number(" 38 "), $28 = Number(" 28 "), $39 = Number(" 39 "), $36 = Number(" 36 "), $36 = Number(" 36 "), $34 = Number(" 34 ")
Global $22 = Number(" 22 "), $24 = Number(" 24 "), $1024 = Number(" 1024 "), $25 = Number(" 25 "), $26 = Number(" 26 "), $27 = Number(" 27 "), $28 = Number(" 28 "), $28 = Number(" 28 "), $29 = Number(" 29 "), $300 = Number(" 300 "), $375 = Number(" 375 "), $14 = Number(" 14 "), $54 = Number(" 54 "), $30 = Number(" 30 "), $31 = Number(" 31 "), $32 = Number(" 32 "), $54 = Number(" 54 "), $31 = Number(" 31 "), $20 = Number(" 20 "), $30 = Number(" 30 "), $31 = Number(" 31 "), $33 = Number(" 33 "), $32 = Number(" 32 "), $34 = Number(" 34 "), $26 = Number(" 26 ")
Global $54 = Number(" 54 "), $40 = Number(" 40 "), $24 = Number(" 24 "), $10 = Number(" 10 "), $11 = Number(" 11 "), $12 = Number(" 12 "), $13 = Number(" 13 "), $14 = Number(" 14 "), $15 = Number(" 15 "), $16 = Number(" 16 "), $17 = Number(" 17 "), $18 = Number(" 18 "), $19 = Number(" 19 "), $20 = Number(" 20 "), $97 = Number(" 97 "), $122 = Number(" 122 "), $15 = Number(" 15 "), $20 = Number(" 20 "), $10 = Number(" 10 "), $15 = Number(" 15 "), $21 = Number(" 21 "), $22 = Number(" 22 "), $25 = Number(" 25 "), $30 = Number(" 30 "), $23 = Number(" 23 ")
Func create_struct_assign_data($FLMOJOCQTZ, $FLJZKJRGZS, $FLSGXLQJNO)
	Local $FLFZXXYXZG[$2]
	$FLFZXXYXZG[$0] = DllStructCreate(("struct;uint bfSize;uint bfReserved;uint bfOffBits;uint biSize;int biWidth;int biHeight;ushort biPlanes;ushort biBitCount;uint biCompression;uint biSizeImage;int biXPelsPerMeter;int biYPelsPerMeter;uint biClrUsed;uint biClrImportant;endstruct;"))
	DllStructSetData($FLFZXXYXZG[$0], ("bfSize"), ($3 * $FLMOJOCQTZ + Mod($FLMOJOCQTZ, $4) * Abs($FLJZKJRGZS)))
	DllStructSetData($FLFZXXYXZG[$0], ("bfReserved"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("bfOffBits"), $54)
	DllStructSetData($FLFZXXYXZG[$0], ("biSize"), $40)
	DllStructSetData($FLFZXXYXZG[$0], ("biWidth"), $FLMOJOCQTZ)
	DllStructSetData($FLFZXXYXZG[$0], ("biHeight"), $FLJZKJRGZS)
	DllStructSetData($FLFZXXYXZG[$0], ("biPlanes"), $1)
	DllStructSetData($FLFZXXYXZG[$0], ("biBitCount"), $24)
	DllStructSetData($FLFZXXYXZG[$0], ("biCompression"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("biSizeImage"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("biXPelsPerMeter"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("biYPelsPerMeter"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("biClrUsed"), $0)
	DllStructSetData($FLFZXXYXZG[$0], ("biClrImportant"), $0)
	$FLFZXXYXZG[$1] = DllStructCreate(("struct;") & _StringRepeat(("byte[") & DllStructGetData($FLFZXXYXZG[$0], ("biWidth")) * $3 & ("];"), DllStructGetData($FLFZXXYXZG[$0], ("biHeight"))) & ("endstruct"))
	Return $FLFZXXYXZG
EndFunc
Func gen_random_string($FLYOOJIBBO, $FLTYAPMIGO)
	Local $FLDKNAGJPD = ("")
	For $FLEZMZOWNO = $0 To Random($FLYOOJIBBO, $FLTYAPMIGO, $1)
		$FLDKNAGJPD &= Chr(Random($97, $122, $1))
	Next
	Return $FLDKNAGJPD
EndFunc
Func file_install_switch($FLSLBKNOFV)
	Local $FLXGRWIIEL = gen_random_string($15, $20)
	Switch $FLSLBKNOFV
		Case $10 To $15
			$FLXGRWIIEL &= (".bmp")
			FileInstall(".\sprite.bmp", @ScriptDir & ("\") & $FLXGRWIIEL)
		Case $25 To $30
			$FLXGRWIIEL &= (".dll")
			FileInstall(".\qr_encoder.dll", @ScriptDir & ("\") & $FLXGRWIIEL)
	EndSwitch
	Return $FLXGRWIIEL
EndFunc
Func GetComputerName()
	Local $FLFNVBVVFI = -$1
	Local $FLFNVBVVFIRAW = DllStructCreate(("struct;dword;char[1024];endstruct"))
	DllStructSetData($FLFNVBVVFIRAW, $1, $1024)
	Local $FLMYEULROX = DllCall(("kernel32.dll"), ("int"), ("GetComputerNameA"), ("ptr"), DllStructGetPtr($FLFNVBVVFIRAW, $2), ("ptr"), DllStructGetPtr($FLFNVBVVFIRAW, $1))
	If $FLMYEULROX[$0] <> $0 Then
		$FLFNVBVVFI = BinaryMid(DllStructGetData($FLFNVBVVFIRAW, $2), $1, DllStructGetData($FLFNVBVVFIRAW, $1))
	EndIf
	Return $FLFNVBVVFI
EndFunc
GUICreate(("CodeIt Plus!"), $300, $375, -$1, -$1)
Func get_data_from_sprite(ByRef $computername_struct)
	Local $FLQVIZHEZM = file_install_switch($14)
	Local $file_descriptor = CreateFile($FLQVIZHEZM)
	If $file_descriptor <> -$1 Then
		Local $file_size = GetFileSize($file_descriptor)
		If $file_size <> -$1 And DllStructGetSize($computername_struct) < $file_size - $54 Then
			Local $file_data_struct = DllStructCreate(("struct;byte[") & $file_size & ("];endstruct"))
			Local $FLSKUANQBG = ReadFile($file_descriptor, $file_data_struct)
			If $FLSKUANQBG <> -$1 Then
				Local $file_data_and_size_struct = DllStructCreate(("struct;byte[54];byte[") & $file_size - $54 & ("];endstruct"), DllStructGetPtr($file_data_struct))
				Local $struct_incrementer = $1
				Local $out_string = ("")
				For $computername_incrementer = $1 To DllStructGetSize($computername_struct)
					Local $computername_character = Number(DllStructGetData($computername_struct, $1, $computername_incrementer))
					For $inner_for_decrementer = $6 To $0 Step -$1
						$computername_character += BitShift(BitAND(Number(DllStructGetData($file_data_and_size_struct, $2, $struct_incrementer)), $1), -$1 * $inner_for_decrementer)
						$struct_incrementer += $1
					Next
					$out_string &= Chr(BitShift($computername_character, $1) + BitShift(BitAND($computername_character, $1), -$7))
				Next
				DllStructSetData($computername_struct, $1, $out_string)
			EndIf
		EndIf
		CloseHandle($file_descriptor)
	EndIf
	DeleteFileA($FLQVIZHEZM)
EndFunc
Func place_flag_in_struct(ByRef $qr_code_struct)
	Local $FLISILAYLN = GetComputerName()
	If $FLISILAYLN <> -$1 Then
		$FLISILAYLN = Binary(StringLower(BinaryToString($FLISILAYLN)))
		Local $computername_struct = DllStructCreate(("struct;byte[") & BinaryLen($FLISILAYLN) & ("];endstruct"))
		DllStructSetData($computername_struct, $1, $FLISILAYLN)
		get_data_from_sprite($computername_struct)
		Local $FLNTTMJFEA = DllStructCreate(("struct;ptr;ptr;dword;byte[32];endstruct"))
		DllStructSetData($FLNTTMJFEA, $3, $32)
		Local $FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptAcquireContextA"), ("ptr"), DllStructGetPtr($FLNTTMJFEA, $1), ("ptr"), $0, ("ptr"), $0, ("dword"), $24, ("dword"), $4026531840)
		If $FLUZYTJACB[$0] <> $0 Then
			$FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptCreateHash"), ("ptr"), DllStructGetData($FLNTTMJFEA, $1), ("dword"), $32780, ("dword"), $0, ("dword"), $0, ("ptr"), DllStructGetPtr($FLNTTMJFEA, $2))
			If $FLUZYTJACB[$0] <> $0 Then
				$FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptHashData"), ("ptr"), DllStructGetData($FLNTTMJFEA, $2), ("struct*"), $computername_struct, ("dword"), DllStructGetSize($computername_struct), ("dword"), $0)
				If $FLUZYTJACB[$0] <> $0 Then
					$FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptGetHashParam"), ("ptr"), DllStructGetData($FLNTTMJFEA, $2), ("dword"), $2, ("ptr"), DllStructGetPtr($FLNTTMJFEA, $4), ("ptr"), DllStructGetPtr($FLNTTMJFEA, $3), ("dword"), $0)
					If $FLUZYTJACB[$0] <> $0 Then
						Local $key_blob_struct = Binary(("0x") & ("08020") & ("00010") & ("66000") & ("02000") & ("0000")) & DllStructGetData($FLNTTMJFEA, $4)
						Local $encrypted_blob = Binary(("0x") & ("CD4B3") & ("2C650") & ("CF21B") & ("DA184") & ("D8913") & ("E6F92") & ("0A37A") & ("4F396") & ("3736C") & ("042C4") & ("59EA0") & ("7B79E") & ("A443F") & ("FD189") & ("8BAE4") & ("9B115") & ("F6CB1") & ("E2A7C") & ("1AB3C") & ("4C256") & ("12A51") & ("9035F") & ("18FB3") & ("B1752") & ("8B3AE") & ("CAF3D") & ("480E9") & ("8BF8A") & ("635DA") & ("F974E") & ("00135") & ("35D23") & ("1E4B7") & ("5B2C3") & ("8B804") & ("C7AE4") & ("D266A") & ("37B36") & ("F2C55") & ("5BF3A") & ("9EA6A") & ("58BC8") & ("F906C") & ("C665E") & ("AE2CE") & ("60F2C") & ("DE38F") & ("D3026") & ("9CC4C") & ("E5BB0") & ("90472") & ("FF9BD") & ("26F91") & ("19B8C") & ("484FE") & ("69EB9") & ("34F43") & ("FEEDE") & ("DCEBA") & ("79146") & ("0819F") & ("B21F1") & ("0F832") & ("B2A5D") & ("4D772") & ("DB12C") & ("3BED9") & ("47F6F") & ("706AE") & ("4411A") & ("52"))
						Local $encrypted_content_struct = DllStructCreate(("struct;ptr;ptr;dword;byte[8192];byte[") & BinaryLen($key_blob_struct) & ("];dword;endstruct"))
						DllStructSetData($encrypted_content_struct, $3, BinaryLen($encrypted_blob))
						DllStructSetData($encrypted_content_struct, $4, $encrypted_blob)
						DllStructSetData($encrypted_content_struct, $5, $key_blob_struct)
						DllStructSetData($encrypted_content_struct, $6, BinaryLen($key_blob_struct))
						Local $FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptAcquireContextA"), ("ptr"), DllStructGetPtr($encrypted_content_struct, $1), ("ptr"), $0, ("ptr"), $0, ("dword"), $24, ("dword"), $4026531840)
						If $FLUZYTJACB[$0] <> $0 Then
							$FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptImportKey"), ("ptr"), DllStructGetData($encrypted_content_struct, $1), ("ptr"), DllStructGetPtr($encrypted_content_struct, $5), ("dword"), DllStructGetData($encrypted_content_struct, $6), ("dword"), $0, ("dword"), $0, ("ptr"), DllStructGetPtr($encrypted_content_struct, $2))
							If $FLUZYTJACB[$0] <> $0 Then
								$FLUZYTJACB = DllCall(("advapi32.dll"), ("int"), ("CryptDecrypt"), ("ptr"), DllStructGetData($encrypted_content_struct, $2), ("dword"), $0, ("dword"), $1, ("dword"), $0, ("ptr"), DllStructGetPtr($encrypted_content_struct, $4), ("ptr"), DllStructGetPtr($encrypted_content_struct, $3))
								If $FLUZYTJACB[$0] <> $0 Then
									Local $decrypted_qr_flag = BinaryMid(DllStructGetData($encrypted_content_struct, $4), $1, DllStructGetData($encrypted_content_struct, $3))
									$beginning_delimiter = Binary(("FLARE"))
									$end_delimiter = Binary(("ERALF"))
									$FLGGGFTGES = BinaryMid($decrypted_qr_flag, $1, BinaryLen($beginning_delimiter))
									$FLNMIATRFT = BinaryMid($decrypted_qr_flag, BinaryLen($decrypted_qr_flag) - BinaryLen($end_delimiter) + $1, BinaryLen($end_delimiter))
									If $beginning_delimiter = $FLGGGFTGES And $end_delimiter = $FLNMIATRFT Then
										DllStructSetData($qr_code_struct, $1, BinaryMid($decrypted_qr_flag, $6, $4))
										DllStructSetData($qr_code_struct, $2, BinaryMid($decrypted_qr_flag, $10, $4))
										DllStructSetData($qr_code_struct, $3, BinaryMid($decrypted_qr_flag, $14, BinaryLen($decrypted_qr_flag) - $18))
									EndIf
								EndIf
								DllCall(("advapi32.dll"), ("int"), ("CryptDestroyKey"), ("ptr"), DllStructGetData($encrypted_content_struct, $2))
							EndIf
							DllCall(("advapi32.dll"), ("int"), ("CryptReleaseContext"), ("ptr"), DllStructGetData($encrypted_content_struct, $1), ("dword"), $0)
						EndIf
					EndIf
				EndIf
				DllCall(("advapi32.dll"), ("int"), ("CryptDestroyHash"), ("ptr"), DllStructGetData($FLNTTMJFEA, $2))
			EndIf
			DllCall(("advapi32.dll"), ("int"), ("CryptReleaseContext"), ("ptr"), DllStructGetData($FLNTTMJFEA, $1), ("dword"), $0)
		EndIf
	EndIf
EndFunc
Func hash_data(ByRef $FLKHFBUYON)
	Local $FLUUPFRKDZ = -$1
	Local $FLQBSFZEZK = DllStructCreate(("struct;ptr;ptr;dword;byte[16];endstruct"))
	DllStructSetData($FLQBSFZEZK, $3, $16)
	Local $FLTRTSURYD = DllCall(("advapi32.dll"), ("int"), ("CryptAcquireContextA"), ("ptr"), DllStructGetPtr($FLQBSFZEZK, $1), ("ptr"), $0, ("ptr"), $0, ("dword"), $24, ("dword"), $4026531840)
	If $FLTRTSURYD[$0] <> $0 Then
		$FLTRTSURYD = DllCall(("advapi32.dll"), ("int"), ("CryptCreateHash"), ("ptr"), DllStructGetData($FLQBSFZEZK, $1), ("dword"), $32771, ("dword"), $0, ("dword"), $0, ("ptr"), DllStructGetPtr($FLQBSFZEZK, $2))
		If $FLTRTSURYD[$0] <> $0 Then
			$FLTRTSURYD = DllCall(("advapi32.dll"), ("int"), ("CryptHashData"), ("ptr"), DllStructGetData($FLQBSFZEZK, $2), ("struct*"), $FLKHFBUYON, ("dword"), DllStructGetSize($FLKHFBUYON), ("dword"), $0)
			If $FLTRTSURYD[$0] <> $0 Then
				$FLTRTSURYD = DllCall(("advapi32.dll"), ("int"), ("CryptGetHashParam"), ("ptr"), DllStructGetData($FLQBSFZEZK, $2), ("dword"), $2, ("ptr"), DllStructGetPtr($FLQBSFZEZK, $4), ("ptr"), DllStructGetPtr($FLQBSFZEZK, $3), ("dword"), $0)
				If $FLTRTSURYD[$0] <> $0 Then
					$FLUUPFRKDZ = DllStructGetData($FLQBSFZEZK, $4)
				EndIf
			EndIf
			DllCall(("advapi32.dll"), ("int"), ("CryptDestroyHash"), ("ptr"), DllStructGetData($FLQBSFZEZK, $2))
		EndIf
		DllCall(("advapi32.dll"), ("int"), ("CryptReleaseContext"), ("ptr"), DllStructGetData($FLQBSFZEZK, $1), ("dword"), $0)
	EndIf
	Return $FLUUPFRKDZ
EndFunc
Func GetVersionEx()
	Local $FLGQBTJBMI = -$1
	Local $FLTPVJCCVQ = DllStructCreate(("struct;dword;dword;dword;dword;dword;byte[128];endstruct"))
	DllStructSetData($FLTPVJCCVQ, $1, DllStructGetSize($FLTPVJCCVQ))
	Local $FLAGHDVGYV = DllCall(("kernel32.dll"), ("int"), ("GetVersionExA"), ("struct*"), $FLTPVJCCVQ)
	If $FLAGHDVGYV[$0] <> $0 Then
		If DllStructGetData($FLTPVJCCVQ, $2) = $6 Then
			If DllStructGetData($FLTPVJCCVQ, $3) = $1 Then
				$FLGQBTJBMI = $0
			EndIf
		EndIf
	EndIf
	Return $FLGQBTJBMI
EndFunc
Func main_gui_control()
	Local $FLOKWZAMXW = GUICtrlCreateInput(("Enter text to encode"), -$1, $5, $300)
	Local $FLKHWWZGNE = GUICtrlCreateButton(("Can haz code?"), -$1, $30, $300)
	Local $FLUHTSIJXF = GUICtrlCreatePic((""), -$1, $55, $300, $300)
	Local $FLXEUAIHLC = GUICtrlCreateMenu(("Help"))
	Local $FLXEUAIHLCITEM = GUICtrlCreateMenuItem(("About CodeIt Plus!"), $FLXEUAIHLC)
	Local $FLPNLTLQHH = file_install_switch($13)
	GUICtrlSetImage($FLUHTSIJXF, $FLPNLTLQHH)
	DeleteFileA($FLPNLTLQHH)
	GUISetState(@SW_SHOW)
	While $1
		Switch GUIGetMsg()
			Case $FLKHWWZGNE
				Local $FLNWBVJLJJ = GUICtrlRead($FLOKWZAMXW)
				If $FLNWBVJLJJ Then
					Local $FLWXDPSIMZ = file_install_switch($26)
					Local $FLNPAPEKEN = DllStructCreate(("struct;dword;dword;byte[3918];endstruct"))
					Local $FLJFOJRIHF = DllCall($FLWXDPSIMZ, ("int:cdecl"), ("justGenerateQRSymbol"), ("struct*"), $FLNPAPEKEN, ("str"), $FLNWBVJLJJ)
					If $FLJFOJRIHF[$0] <> $0 Then
						place_flag_in_struct($FLNPAPEKEN)
						Local $FLBVOKDXKG = create_struct_assign_data((DllStructGetData($FLNPAPEKEN, $1) * DllStructGetData($FLNPAPEKEN, $2)), (DllStructGetData($FLNPAPEKEN, $1) * DllStructGetData($FLNPAPEKEN, $2)), $1024)
						$FLJFOJRIHF = DllCall($FLWXDPSIMZ, ("int:cdecl"), ("justConvertQRSymbolToBitmapPixels"), ("struct*"), $FLNPAPEKEN, ("struct*"), $FLBVOKDXKG[$1])
						If $FLJFOJRIHF[$0] <> $0 Then
							$FLPNLTLQHH = gen_random_string($25, $30) & (".bmp")
							ARELASSEHHA($FLBVOKDXKG, $FLPNLTLQHH)
						EndIf
					EndIf
					DeleteFileA($FLWXDPSIMZ)
				Else
					$FLPNLTLQHH = file_install_switch($11)
				EndIf
				GUICtrlSetImage($FLUHTSIJXF, $FLPNLTLQHH)
				DeleteFileA($FLPNLTLQHH)
			Case $FLXEUAIHLCITEM
				Local $FLOMTRKAWP = ("This program generates QR codes using QR Code Generator (https://www.nayuki.io/page/qr-code-generator-library) developed by Nayuki. ")
				$FLOMTRKAWP &= ("QR Code Generator is available on GitHub (https://github.com/nayuki/QR-Code-generator) and open-sourced under the following permissive MIT License (https://github.com/nayuki/QR-Code-generator#license):")
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= ("Copyright © 2020 Project Nayuki. (MIT License)")
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= ("https://www.nayuki.io/page/qr-code-generator-library")
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= ("Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the Software), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:")
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= ("1. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.")
				$FLOMTRKAWP &= @CRLF
				$FLOMTRKAWP &= ("2. The Software is provided as is, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.")
				MsgBox($4096, ("About CodeIt Plus!"), $FLOMTRKAWP)
			Case -$3
				ExitLoop
		EndSwitch
	WEnd
EndFunc
Func AREPQQKAETO($FLMWACUFRE, $FLJXAIVJLD)
	Local $FLJIYELUHX = -$1
	Local $FLMWACUFREHEADERMAGIC = DllStructCreate(("struct;ushort;endstruct"))
	DllStructSetData($FLMWACUFREHEADERMAGIC, $1, $19778)
	Local $FLIVPIOGMF = CreateFile($FLJXAIVJLD, False)
	If $FLIVPIOGMF <> -$1 Then
		Local $FLCHLKBEND = WriteFile_at_location($FLIVPIOGMF, DllStructGetPtr($FLMWACUFREHEADERMAGIC), DllStructGetSize($FLMWACUFREHEADERMAGIC))
		If $FLCHLKBEND <> -$1 Then
			$FLCHLKBEND = WriteFile_at_location($FLIVPIOGMF, DllStructGetPtr($FLMWACUFRE[$0]), DllStructGetSize($FLMWACUFRE[$0]))
			If $FLCHLKBEND <> -$1 Then
				$FLJIYELUHX = $0
			EndIf
		EndIf
		CloseHandle($FLIVPIOGMF)
	EndIf
	Return $FLJIYELUHX
EndFunc
main_gui_control()
Func ARELASSEHHA($FLBAQVUJSL, $FLKELSUUIY)
	Local $FLEFOUBDXT = -$1
	Local $FLAMTLCNCX = AREPQQKAETO($FLBAQVUJSL, $FLKELSUUIY)
	If $FLAMTLCNCX <> -$1 Then
		Local $FLVIKMHXWU = CreateFile($FLKELSUUIY, True)
		If $FLVIKMHXWU <> -$1 Then
			Local $FLWLDJLWRQ = Abs(DllStructGetData($FLBAQVUJSL[$0], ("biHeight")))
			Local $FLUMNOETUU = DllStructGetData($FLBAQVUJSL[$0], ("biHeight")) > $0 ? $FLWLDJLWRQ - $1 : $0
			Local $FLQPHCJGTP = DllStructCreate(("struct;byte;byte;byte;endstruct"))
			For $FLLRCVAWMX = $0 To $FLWLDJLWRQ - $1
				$FLAMTLCNCX = WriteFile_at_location($FLVIKMHXWU, DllStructGetPtr($FLBAQVUJSL[$1], Abs($FLUMNOETUU - $FLLRCVAWMX) + $1), DllStructGetData($FLBAQVUJSL[$0], ("biWidth")) * $3)
				If $FLAMTLCNCX = -$1 Then ExitLoop
				$FLAMTLCNCX = WriteFile_at_location($FLVIKMHXWU, DllStructGetPtr($FLQPHCJGTP), Mod(DllStructGetData($FLBAQVUJSL[$0], ("biWidth")), $4))
				If $FLAMTLCNCX = -$1 Then ExitLoop
			Next
			If $FLAMTLCNCX <> -$1 Then
				$FLEFOUBDXT = $0
			EndIf
			CloseHandle($FLVIKMHXWU)
		EndIf
	EndIf
	Return $FLEFOUBDXT
EndFunc
Func CreateFile($FLRRITEUXD)
	Local $FLRICHEMYE = DllCall(("kernel32.dll"), ("ptr"), ("CreateFile"), ("str"), @ScriptDir & ("\") & $FLRRITEUXD, ("uint"), $2147483648, ("uint"), $0, ("ptr"), $0, ("uint"), $3, ("uint"), $128, ("ptr"), $0)
	Return $FLRICHEMYE[$0]
EndFunc
Func CreateFile($FLZXEPIOOK, $FLZCODZOEP = True)
	Local $FLOGMFCAKQ = DllCall(("kernel32.dll"), ("ptr"), ("CreateFile"), ("str"), @ScriptDir & ("\") & $FLZXEPIOOK, ("uint"), $1073741824, ("uint"), $0, ("ptr"), $0, ("uint"), $FLZCODZOEP ? 3 : $2, ("uint"), $128, ("ptr"), $0)
	Return $FLOGMFCAKQ[$0]
EndFunc
GUIDelete()
Func WriteFile_at_location($FLLSCZDYHR, $FLBFZGXBCY, $FLUTGABJFJ)
	If $FLLSCZDYHR <> -$1 Then
		Local $FLVFNKOSUF = DllCall(("kernel32.dll"), ("uint"), ("SetFilePointer"), ("ptr"), $FLLSCZDYHR, ("long"), $0, ("ptr"), $0, ("uint"), $2)
		If $FLVFNKOSUF[$0] <> -$1 Then
			Local $FLWZFBBKTO = DllStructCreate(("uint"))
			$FLVFNKOSUF = DllCall(("kernel32.dll"), ("ptr"), ("WriteFile"), ("ptr"), $FLLSCZDYHR, ("ptr"), $FLBFZGXBCY, ("uint"), $FLUTGABJFJ, ("ptr"), DllStructGetPtr($FLWZFBBKTO), ("ptr"), $0)
			If $FLVFNKOSUF[$0] <> $0 And DllStructGetData($FLWZFBBKTO, $1) = $FLUTGABJFJ Then
				Return $0
			EndIf
		EndIf
	EndIf
	Return -$1
EndFunc
Func ReadFile($FLFDNKXWZE, ByRef $FLGFDYKDOR)
	Local $FLQCVTZTHZ = DllStructCreate(("struct;dword;endstruct"))
	Local $FLQNSBZFSF = DllCall(("kernel32.dll"), ("int"), ("ReadFile"), ("ptr"), $FLFDNKXWZE, ("struct*"), $FLGFDYKDOR, ("dword"), DllStructGetSize($FLGFDYKDOR), ("struct*"), $FLQCVTZTHZ, ("ptr"), $0)
	Return $FLQNSBZFSF[$0]
EndFunc
Func CloseHandle($FLDIAPCPTM)
	Local $FLHVHGVTXM = DllCall(("kernel32.dll"), ("int"), ("CloseHandle"), ("ptr"), $FLDIAPCPTM)
	Return $FLHVHGVTXM[$0]
EndFunc
Func DeleteFileA($FLXLJYOYCL)
	Local $FLAUBRMOIP = DllCall(("kernel32.dll"), ("int"), ("DeleteFileA"), ("str"), $FLXLJYOYCL)
	Return $FLAUBRMOIP[$0]
EndFunc
Func GetFileSize($FLPXHQHCAV)
	Local $FLZMCDHZWH = -$1
	Local $FLZTPEGDEG = DllStructCreate(("struct;dword;endstruct"))
	Local $FLEKMCMPDL = DllCall(("kernel32.dll"), ("dword"), ("GetFileSize"), ("ptr"), $FLPXHQHCAV, ("struct*"), $FLZTPEGDEG)
	If $FLEKMCMPDL <> -$1 Then
		$FLZMCDHZWH = $FLEKMCMPDL[$0] + Number(DllStructGetData($FLZTPEGDEG, $1))
	EndIf
	Return $FLZMCDHZWH
EndFunc
Func create_os_array()
	Local $DLIT = "7374727563743b75696e7420626653697a653b75696e7420626652657365727665643b75696e742062664f6666426974733b"
	$DLIT &= "75696e7420626953697a653b696e7420626957696474683b696e742062694865696768743b7573686f7274206269506c616e"
	$DLIT &= "65733b7573686f7274206269426974436f756e743b75696e74206269436f6d7072657373696f6e3b75696e7420626953697a"
	$DLIT &= "65496d6167653b696e742062695850656c735065724d657465723b696e742062695950656c735065724d657465723b75696e"
	$DLIT &= "74206269436c72557365643b75696e74206269436c72496d706f7274616e743b656e647374727563743b4FD5$626653697a6"
	$DLIT &= "54FD5$626652657365727665644FD5$62664f6666426974734FD5$626953697a654FD5$626957696474684FD5$6269486569"
	$DLIT &= "6768744FD5$6269506c616e65734FD5$6269426974436f756e744FD5$6269436f6d7072657373696f6e4FD5$626953697a65"
	$DLIT &= "496d6167654FD5$62695850656c735065724d657465724FD5$62695950656c735065724d657465724FD5$6269436c7255736"
	$DLIT &= "5644FD5$6269436c72496d706f7274616e744FD5$7374727563743b4FD5$627974655b4FD5$5d3b4FD5$656e647374727563"
	$DLIT &= "744FD5$4FD5$2e626d704FD5$5c4FD5$2e646c6c4FD5$7374727563743b64776f72643b636861725b313032345d3b656e647"
	$DLIT &= "374727563744FD5$6b65726e656c33322e646c6c4FD5$696e744FD5$476574436f6d70757465724e616d65414FD5$7074724"
	$DLIT &= "FD5$436f6465497420506c7573214FD5$7374727563743b627974655b4FD5$5d3b656e647374727563744FD5$73747275637"
	$DLIT &= "43b627974655b35345d3b627974655b4FD5$7374727563743b7074723b7074723b64776f72643b627974655b33325d3b656e"
	$DLIT &= "647374727563744FD5$61647661706933322e646c6c4FD5$437279707441637175697265436f6e74657874414FD5$64776f7"
	$DLIT &= "2644FD5$4372797074437265617465486173684FD5$437279707448617368446174614FD5$7374727563742a4FD5$4372797"
	$DLIT &= "07447657448617368506172616d4FD5$30784FD5$30383032304FD5$30303031304FD5$36363030304FD5$30323030304FD5"
	$DLIT &= "$303030304FD5$43443442334FD5$32433635304FD5$43463231424FD5$44413138344FD5$44383931334FD5$45364639324"
	$DLIT &= "FD5$30413337414FD5$34463339364FD5$33373336434FD5$30343243344FD5$35394541304FD5$37423739454FD5$413434"
	$DLIT &= "33464FD5$46443138394FD5$38424145344FD5$39423131354FD5$46364342314FD5$45324137434FD5$31414233434FD5$3"
	$DLIT &= "4433235364FD5$31324135314FD5$39303335464FD5$31384642334FD5$42313735324FD5$38423341454FD5$43414633444"
	$DLIT &= "FD5$34383045394FD5$38424638414FD5$36333544414FD5$46393734454FD5$30303133354FD5$33354432334FD5$314534"
	$DLIT &= "42374FD5$35423243334FD5$38423830344FD5$43374145344FD5$44323636414FD5$33374233364FD5$46324335354FD5$3"
	$DLIT &= "5424633414FD5$39454136414FD5$35384243384FD5$46393036434FD5$43363635454FD5$41453243454FD5$36304632434"
	$DLIT &= "FD5$44453338464FD5$44333032364FD5$39434334434FD5$45354242304FD5$39303437324FD5$46463942444FD5$323646"
	$DLIT &= "39314FD5$31394238434FD5$34383446454FD5$36394542394FD5$33344634334FD5$46454544454FD5$44434542414FD5$3"
	$DLIT &= "7393134364FD5$30383139464FD5$42323146314FD5$30463833324FD5$42324135444FD5$34443737324FD5$44423132434"
	$DLIT &= "FD5$33424544394FD5$34374636464FD5$37303641454FD5$34343131414FD5$35324FD5$7374727563743b7074723b70747"
	$DLIT &= "23b64776f72643b627974655b383139325d3b627974655b4FD5$5d3b64776f72643b656e647374727563744FD5$437279707"
	$DLIT &= "4496d706f72744b65794FD5$4372797074446563727970744FD5$464c4152454FD5$4552414c464FD5$43727970744465737"
	$DLIT &= "4726f794b65794FD5$437279707452656c65617365436f6e746578744FD5$437279707444657374726f79486173684FD5$73"
	$DLIT &= "74727563743b7074723b7074723b64776f72643b627974655b31365d3b656e647374727563744FD5$7374727563743b64776"
	$DLIT &= "f72643b64776f72643b64776f72643b64776f72643b64776f72643b627974655b3132385d3b656e647374727563744FD5$47"
	$DLIT &= "657456657273696f6e4578414FD5$456e746572207465787420746f20656e636f64654FD5$43616e2068617a20636f64653f"
	$DLIT &= "4FD5$4FD5$48656c704FD5$41626f757420436f6465497420506c7573214FD5$7374727563743b64776f72643b64776f7264"
	$DLIT &= "3b627974655b333931385d3b656e647374727563744FD5$696e743a636465636c4FD5$6a75737447656e6572617465515253"
	$DLIT &= "796d626f6c4FD5$7374724FD5$6a757374436f6e76657274515253796d626f6c546f4269746d6170506978656c734FD5$546"
	$DLIT &= "869732070726f6772616d2067656e65726174657320515220636f646573207573696e6720515220436f64652047656e65726"
	$DLIT &= "1746f72202868747470733a2f2f7777772e6e6179756b692e696f2f706167652f71722d636f64652d67656e657261746f722"
	$DLIT &= "d6c6962726172792920646576656c6f706564206279204e6179756b692e204FD5$515220436f64652047656e657261746f72"
	$DLIT &= "20697320617661696c61626c65206f6e20476974487562202868747470733a2f2f6769746875622e636f6d2f6e6179756b69"
	$DLIT &= "2f51522d436f64652d67656e657261746f722920616e64206f70656e2d736f757263656420756e6465722074686520666f6c"
	$DLIT &= "6c6f77696e67207065726d697373697665204d4954204c6963656e7365202868747470733a2f2f6769746875622e636f6d2f"
	$DLIT &= "6e6179756b692f51522d436f64652d67656e657261746f72236c6963656e7365293a4FD5$436f7079726967687420c2a9203"
	$DLIT &= "23032302050726f6a656374204e6179756b692e20284d4954204c6963656e7365294FD5$68747470733a2f2f7777772e6e61"
	$DLIT &= "79756b692e696f2f706167652f71722d636f64652d67656e657261746f722d6c6962726172794FD5$5065726d697373696f6"
	$DLIT &= "e20697320686572656279206772616e7465642c2066726565206f66206368617267652c20746f20616e7920706572736f6e2"
	$DLIT &= "06f627461696e696e67206120636f7079206f66207468697320736f66747761726520616e64206173736f636961746564206"
	$DLIT &= "46f63756d656e746174696f6e2066696c6573202874686520536f667477617265292c20746f206465616c20696e207468652"
	$DLIT &= "0536f66747761726520776974686f7574207265737472696374696f6e2c20696e636c7564696e6720776974686f7574206c6"
	$DLIT &= "96d69746174696f6e207468652072696768747320746f207573652c20636f70792c206d6f646966792c206d657267652c207"
	$DLIT &= "075626c6973682c20646973747269627574652c207375626c6963656e73652c20616e642f6f722073656c6c20636f7069657"
	$DLIT &= "3206f662074686520536f6674776172652c20616e6420746f207065726d697420706572736f6e7320746f2077686f6d20746"
	$DLIT &= "86520536f667477617265206973206675726e697368656420746f20646f20736f2c207375626a65637420746f20746865206"
	$DLIT &= "66f6c6c6f77696e6720636f6e646974696f6e733a4FD5$312e205468652061626f766520636f70797269676874206e6f7469"
	$DLIT &= "636520616e642074686973207065726d697373696f6e206e6f74696365207368616c6c20626520696e636c7564656420696e"
	$DLIT &= "20616c6c20636f70696573206f72207375627374616e7469616c20706f7274696f6e73206f662074686520536f6674776172"
	$DLIT &= "652e4FD5$322e2054686520536f6674776172652069732070726f76696465642061732069732c20776974686f75742077617"
	$DLIT &= "272616e7479206f6620616e79206b696e642c2065787072657373206f7220696d706c6965642c20696e636c7564696e67206"
	$DLIT &= "27574206e6f74206c696d6974656420746f207468652077617272616e74696573206f66206d65726368616e746162696c697"
	$DLIT &= "4792c206669746e65737320666f72206120706172746963756c617220707572706f736520616e64206e6f6e696e6672696e6"
	$DLIT &= "7656d656e742e20496e206e6f206576656e74207368616c6c2074686520617574686f7273206f7220636f707972696768742"
	$DLIT &= "0686f6c64657273206265206c6961626c6520666f7220616e7920636c61696d2c2064616d61676573206f72206f746865722"
	$DLIT &= "06c696162696c6974792c207768657468657220696e20616e20616374696f6e206f6620636f6e74726163742c20746f72742"
	$DLIT &= "06f72206f74686572776973652c2061726973696e672066726f6d2c206f7574206f66206f7220696e20636f6e6e656374696"
	$DLIT &= "f6e20776974682074686520536f667477617265206f722074686520757365206f72206f74686572206465616c696e6773206"
	$DLIT &= "96e2074686520536f6674776172652e4FD5$7374727563743b7573686f72743b656e647374727563744FD5$7374727563743"
	$DLIT &= "b627974653b627974653b627974653b656e647374727563744FD5$43726561746546696c654FD5$75696e744FD5$53657446"
	$DLIT &= "696c65506f696e7465724FD5$6c6f6e674FD5$577269746546696c654FD5$7374727563743b64776f72643b656e647374727"
	$DLIT &= "563744FD5$5265616446696c654FD5$436c6f736548616e646c654FD5$44656c65746546696c65414FD5$47657446696c655"
	$DLIT &= "3697a65"
	Global $STRINGS_ARR = StringSplit($DLIT, "4FD5$", 1)
EndFunc
Func ($FLQLNXGXBP)
	Local $FLQLNXGXBP_
	For $FLRCTQRYUB = 1 To StringLen($FLQLNXGXBP) Step 2
		$FLQLNXGXBP_ &= Chr(Dec(StringMid($FLQLNXGXBP, $FLRCTQRYUB, 2)))
	Next
	Return $FLQLNXGXBP_
EndFunc
; DeTokenise by myAut2Exe >The Open Source AutoIT/AutoHotKey script decompiler< 2.15 build(212)
