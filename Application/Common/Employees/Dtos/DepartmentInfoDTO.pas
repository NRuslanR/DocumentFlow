unit DepartmentInfoDTO;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;
  
type

  TDepartmentInfoDTO = class (TInterfacedObject, IGetSelf)

    public

      Id: Variant;
      Code: String;
      Name: String;

      constructor Create;
      constructor CreateFrom(
        const Id: Variant;
        const Code, Name: String
      );

      function GetSelf: TObject;
      
  end;

  TDepartmentsInfoDTOEnumerator = class (TInterfaceListEnumerator)

    private

      function GetCurrentDepartmentInfoDTO: TDepartmentInfoDTO;

    public

      property Current: TDepartmentInfoDTO
      read GetCurrentDepartmentInfoDTO;

  end;
  
  TDepartmentsInfoDTO = class (TInterfaceList, IGetSelf)

    private

      function GetDepartmentInfoDTOByIndex(Index: Integer): TDepartmentInfoDTO;
      procedure SetDepartmentInfoDTOByIndex(
        Index: Integer;
        Value: TDepartmentInfoDTO
      );

    public

      function GetSelf: TObject;
      
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

function TDepartmentInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

{ TDepartmentsInfoDTOEnumerator }

function TDepartmentsInfoDTOEnumerator.GetCurrentDepartmentInfoDTO: TDepartmentInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := GetCurrent;

  Supports(Intf, IGetSelf, Target);
  
  Result := TDepartmentInfoDTO(Target.Self);
  
end;

{ TDepartmentsInfoDTO }

function TDepartmentsInfoDTO.Add(DepartmentInfoDTO: TDepartmentInfoDTO): Integer;
begin

  Result := inherited Add(DepartmentInfoDTO);

end;

function TDepartmentsInfoDTO.GetDepartmentInfoDTOByIndex(
  Index: Integer): TDepartmentInfoDTO;
var
    Intf: IInterface;
    Target: IGetSelf;
begin

  Intf := Get(Index);

  Supports(Intf, IGetSelf, Target);

  Result := TDepartmentInfoDTO(Target.Self);

end;

function TDepartmentsInfoDTO.GetEnumerator: TDepartmentsInfoDTOEnumerator;
begin

  Result := TDepartmentsInfoDTOEnumerator.Create(Self);
  
end;

function TDepartmentsInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDepartmentsInfoDTO.Remove(DepartmentInfoDTO: TDepartmentInfoDTO);
begin

  inherited Remove(DepartmentInfoDTO);
  
end;

procedure TDepartmentsInfoDTO.SetDepartmentInfoDTOByIndex(Index: Integer;
  Value: TDepartmentInfoDTO);
begin

  Put(Index, Value);
  
end;

end.

