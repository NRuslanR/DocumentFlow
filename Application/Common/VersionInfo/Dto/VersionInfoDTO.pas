unit VersionInfoDTO;

interface

type

  TVersionInfoDTO = class
    public
      Id: Variant;
      VersionNumber: Variant;
      Date: Variant;
      Description: Variant;
      FilePath: Variant;
      Visible: Boolean;

      constructor Create;
  end;


implementation

uses

  Variants;

{ TVersionInfoDTO }

constructor TVersionInfoDTO.Create;
begin
  inherited;

  Id := Null;
  VersionNumber := Null;
  Date := Null;
  Description := Null;
  FilePath := Null;
  Visible := False;

end;

end.
