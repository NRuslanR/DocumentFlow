unit VersionInfoDTOs;

interface

uses

  SysUtils,
  Classes;

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

  TVersionInfoDTOs = class;
  
  TVersionInfoDTOsEnumerator = class (TListEnumerator)

    private

      function GetCurrentVersionInfoDTO:
        TVersionInfoDTO;

    public

      constructor Create(
        VersionInfoDTOs: TVersionInfoDTOs
      );

      property Current: TVersionInfoDTO
      read GetCurrentVersionInfoDTO;

  end;

  TVersionInfoDTOs = class (TList)

    private

      function GetVersionInfoDTOByIndex(
        Index: Integer
      ): TVersionInfoDTO;

      procedure SetVersionInfoDTOByIndex(
        Index: Integer;
        VersionInfoDTO: TVersionInfoDTO
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(
        VersionInfoDTO: TVersionInfoDTO
      ): Integer;

      function FindById(const VersionId: Variant): TVersionInfoDTO;
      
      function GetEnumerator: TVersionInfoDTOsEnumerator;

      property Items[Index: Integer]: TVersionInfoDTO
      read GetVersionInfoDTOByIndex
      write SetVersionInfoDTOByIndex; default;
  
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

{ TVersionsInfoDTOEnumerator }

constructor TVersionInfoDTOsEnumerator.Create(
  VersionInfoDTOs: TVersionInfoDTOs);
begin
  inherited Create(VersionInfoDTOs);
end;

function TVersionInfoDTOsEnumerator.GetCurrentVersionInfoDTO: TVersionInfoDTO;
begin
  Result := TVersionInfoDTO(GetCurrent);
end;

{ TVersionsInfoDTO }

function TVersionInfoDTOs.Add(VersionInfoDTO: TVersionInfoDTO): Integer;
begin
  Result := inherited Add(VersionInfoDTO);
end;

function TVersionInfoDTOs.FindById(const VersionId: Variant): TVersionInfoDTO;
begin
  for Result in Self do
    if Result.Id = VersionId then
      Exit;

  Result := nil;

end;

function TVersionInfoDTOs.GetEnumerator: TVersionInfoDTOsEnumerator;
begin
  Result := TVersionInfoDTOsEnumerator.Create(Self);
end;

function TVersionInfoDTOs.GetVersionInfoDTOByIndex(
  Index: Integer): TVersionInfoDTO;
begin
  Result := TVersionInfoDTO(Get(Index));
end;

procedure TVersionInfoDTOs.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action = lnDeleted then
    if Assigned(Ptr) then
      TVersionInfoDTO(Ptr).Destroy;
end;

procedure TVersionInfoDTOs.SetVersionInfoDTOByIndex(Index: Integer;
  VersionInfoDTO: TVersionInfoDTO);
begin
  Put(Index, VersionInfoDTO);

end;

end.
