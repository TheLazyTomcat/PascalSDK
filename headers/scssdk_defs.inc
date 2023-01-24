{$IF defined(CPUX86_64) or defined(CPUX64)}
  {$DEFINE SCS_ARCHITECTURE_x64}
{$ELSEIF defined(CPU386)}
  {$DEFINE SCS_ARCHITECTURE_x86}
{$ELSE}
  {$MESSAGE Fatal 'Unsupported CPU architecture'}
{$IFEND}

{$IF Defined(WINDOWS) or Defined(MSWINDOWS)}
  {$DEFINE Windows}
{$IFEND}

{$IFDEF FPC}
  {$MODE ObjFPC}
  {$INLINE ON}
  {$DEFINE CanInline}
{$ELSE}
  {$IF CompilerVersion >= 17 then}  // Delphi 2005+
    {$DEFINE CanInline}
  {$ELSE}
    {$UNDEF CanInline}
  {$IFEND}
{$ENDIF}
{$H+}

{$IFDEF Debug}
  {$DEFINE AssertTypeSize}
{$ELSE}
  {$UNDEF AssertTypeSize}
{$ENDIF}