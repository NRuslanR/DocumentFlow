unit DepartmentInfoDTO;

interface

uses

  SysUtils,
  Classes;
  
type

  TDepartmentInfoDTO = class

    public

      Id: Variant;
      Code: String;
      Name: String;

      constructor Create;
      constructor CreateFrom(
        const Id: Variant;
        const Code, Name: String
      );
      
  end;

  TDepartmentsInfoDTOEnumerator = class (TListEnumerator)

    private

      function GetCurrentDepartmentInfoDTO: TDepartmentInfoDTO;

    public

      property Current: TDepartmentInfoDTO
      read GetCurrentDepartmentInfoDTO;

  end;
  
  TDepartmentsInfoDTO = class (TList)

    private

      function GetDepartmentInfoDTOByIndex(Index: Integer): TDepartmentInfoDTO;
      procedure SetDepartmentInfoDTOByIndex(
        Index: Integer;
        Value: TDepartmentInfoDTO
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
      
    public

      function Add(DepartmentInfoDTO: TDepartmentInfoDTO): Integer;
      procedure Remove(DepartmentInfoDTO: TDepartmentInfoDTO);
      
      function GetEnumerator: TDepartmentsInfoDTOEnumerator;

      property Items[Index: Integer]: TDepartmentInfoDTO
      read GetDepartmentInfoDTOByIndex write SetDepartmentInfoDTOByIndex; default;

  end;
  
implementation

uses

  Variants;

{ TDepartmentInfoDTO }

constructor TDepartmentInfoDTO.Create;
begin

  inherited;

  Id := Null;
  
end;

constructor TDepartmentInfoDTO.CreateFrom(const Id: Variant; const Code,
  Name: String);
begin

  inherited Create;

  Self.Id := Id;
  Self.Code := Code;
  Self.Name := Name;
  
end;

{ TDepartmentsInfoDTOEnumerator }

function TDepartmentsInfoDTOEnumerator.GetCurrentDepartmentInfoDTO: TDepartmentInfoDTO;
begin

  Result := TDepartmentInfoDTO(GetCurrent);
  
end;

{ TDepartmentsInfoDTO }

function TDepartmentsInfoDTO.Add(DepartmentInfoDTO: TDepartmentInfoDTO): Integer;
begin

  Result := inherited Add(DepartmentInfoDTO);

end;

function TDepartmentsInfoDTO.GetDepartmentInfoDTOByIndex(
  Index: Integer): TDepartmentInfoDTO;
begin

  Result := TDepartmentInfoDTO(Get(Index));

end;

function TDepartmentsInfoDTO.GetEnumerator: TDepartmentsInfoDTOEnumerator;
begin

  Result := TDepartmentsInfoDTOEnumerator.Create(Self);
  
end;

procedure TDepartmentsInfoDTO.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    if Assigned(Ptr) then
      TDepartmentInfoDTO(Ptr).Destroy;

end;

procedure TDepartmentsInfoDTO.Remove(DepartmentInfoDTO: TDepartmentInfoDTO);
begin

  Extract(DepartmentInfoDTO);
  
end;

procedure TDepartmentsInfoDTO.SetDepartmentInfoDTOByIndex(Index: Integer;
  Value: TDepartmentInfoDTO);
begin

  Put(Index, Value);
  
end;

end.
