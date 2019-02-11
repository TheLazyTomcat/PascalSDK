{$IF defined(CPUX86_64) or defined(CPUX64)}
  {$DEFINE SCS_ARCHITECTURE_x64}
{$ELSEIF defined(CPU386)}
  {$DEFINE SCS_ARCHITECTURE_x86}
{$ELSE}
  {$MESSAGE Fatal 'Unsupported CPU architecture'}
{$IFEND}

{$IFDEF FPC}
  {$MODE ObjFPC}{$H+}
  {$INLINE ON}
  {$DEFINE CanInline}
  {$IFNDEF PurePascal}
    {$ASMMODE Intel}
  {$ENDIF}
{$ELSE}
  {$IF CompilerVersion >= 17 then}  // Delphi 2005+
    {$DEFINE CanInline}
  {$ELSE}
    {$UNDEF CanInline}
  {$IFEND}
{$ENDIF}

{$IFDEF Debug}
  {$DEFINE AssertTypeSize}
{$ELSE}
  {$UNDEF AssertTypeSize}
{$ENDIF}
