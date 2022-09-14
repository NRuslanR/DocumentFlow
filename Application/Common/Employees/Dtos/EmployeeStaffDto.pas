unit EmployeeStaffDto;

interface

uses

  VariantListUnit,
  SysUtils,
  Classes;

type

  TEmployeeStaffDto = class

    private

      FDepartmentIds: TVariantList;
      FEmployeeRoleIds: TVariantList;
      
      procedure SetDepartmentIds(const Value: TVariantList);
      procedure SetEmployeeRoleIds(const Value: TVariantList);
      
    public

      destructor Destroy; override;
      
      constructor Create(
        DepartmentIds: TVariantList;
        EmployeeRoleIds: TVariantList
      );


      property DepartmentIds: TVariantList read FDepartmentIds write SetDepartmentIds;
      property EmployeeRoleIds: TVariantList read FEmployeeRoleIds write SetEmployeeRoleIds;
    
  end;

  TEmployeeStaffDtos = class;

  TEmployeeStaffDtosEnumerator = class (TListEnumerator)

    private

      function GetCurrentEmployeeStaffDto: TEmployeeStaffDto;

    public

      constructor Create(EmployeeStaffDtos: TEmployeeStaffDtos);

      property Current: TEmployeeStaffDto
      read GetCurrentEmployeeStaffDto;
      
  end;

  TEmployeeStaffDtos = class (TList)

    private

      function GetEmployeeStaffDtoByIndex(Index: Integer): TEmployeeStaffDto;
      procedure SetEmployeeStaffDtoByIndex(
        Index: Integer;
        Value: TEmployeeStaffDto
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(EmployeeStaffDto: TEmployeeStaffDto): Integer;

      function GetEnumerator: TEmployeeStaffDtosEnumerator;
      
      property Items[Index: Integer]: TEmployeeStaffDto
      read GetEmployeeStaffDtoByIndex
      write SetEmployeeStaffDtoByIndex; default;
  
  end;

implementation

{ TEmployeeStaffDto }

constructor TEmployeeStaffDto.Create(
  DepartmentIds,
  EmployeeRoleIds: TVariantList
);
begin

  inherited Create;

  Self.DepartmentIds := DepartmentIds;
  Self.EmployeeRoleIds := EmployeeRoleIds;
  
end;

destructor TEmployeeStaffDto.Destroy;
begin

  FreeAndNil(FDepartmentIds);
  FreeAndNil(FEmployeeRoleIds);
  
  inherited;

end;

procedure TEmployeeStaffDto.SetDepartmentIds(const Value: TVariantList);
begin

  if FDepartmentIds = Value then Exit;

  FreeAndNil(FDepartmentIds);
  
  FDepartmentIds := Value;

end;

procedure TEmployeeStaffDto.SetEmployeeRoleIds(const Value: TVariantList);
begin

  if FEmployeeRoleIds = Value then Exit;

  FreeAndNil(FEmployeeRoleIds);
  
  FEmployeeRoleIds := Value;

end;

{ TEmployeeStaffDtosEnumerator }

constructor TEmployeeStaffDtosEnumerator.Create(
  EmployeeStaffDtos: TEmployeeStaffDtos);
begin

  inherited Create(EmployeeStaffDtos);
  
end;

function TEmployeeStaffDtosEnumerator.GetCurrentEmployeeStaffDto: TEmployeeStaffDto;
begin

  Result := TEmployeeStaffDto(GetCurrent);
  
end;

{ TEmployeeStaffDtos }

function TEmployeeStaffDtos.Add(EmployeeStaffDto: TEmployeeStaffDto): Integer;
begin

  Result := inherited Add(EmployeeStaffDto);

end;

function TEmployeeStaffDtos.GetEmployeeStaffDtoByIndex(
  Index: Integer): TEmployeeStaffDto;
begin

  Result := TEmployeeStaffDto(Get(Index));
  
end;

function TEmployeeStaffDtos.GetEnumerator: TEmployeeStaffDtosEnumerator;
begin

  Result := TEmployeeStaffDtosEnumerator.Create(Self);
  
end;

procedure TEmployeeStaffDtos.Notify(Ptr: Pointer; Action: TListNotification);
begin

  if Action = lnDeleted then
    TEmployeeStaffDto(Ptr).Destroy;

end;

procedure TEmployeeStaffDtos.SetEmployeeStaffDtoByIndex(Index: Integer;
  Value: TEmployeeStaffDto);
begin

  Put(Index, Value);
  
end;

end.
