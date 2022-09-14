unit EmployeeChargePerformingUnitDto;

interface

uses

  EmployeeStaffDto,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TEmployeeChargePerformingUnitDto = class

    private

      FPerformingStaffDtos: TEmployeeStaffDtos;
      FEmployeeWorkGroupIds: TVariantList;

      procedure SetEmployeeWorkGroupIds(const Value: TVariantList);
      procedure SetPerformingStaffDtos(const Value: TEmployeeStaffDtos);

    public

      destructor Destroy; override;

      constructor Create; overload;

      constructor Create(
        PerformingStaffDtos: TEmployeeStaffDtos;
        EmployeeWorkGroupIds: TVariantList
      ); overload;
      
    published

      property PerformingStaffDtos: TEmployeeStaffDtos
      read FPerformingStaffDtos write SetPerformingStaffDtos;
      
      property EmployeeWorkGroupIds: TVariantList
      read FEmployeeWorkGroupIds write SetEmployeeWorkGroupIds;

  end;

implementation

{ TEmployeeChargePerformingUnitDto }

constructor TEmployeeChargePerformingUnitDto.Create;
begin

  inherited;

  Self.EmployeeWorkGroupIds := TVariantList.Create;
  
end;

constructor TEmployeeChargePerformingUnitDto.Create(
  PerformingStaffDtos: TEmployeeStaffDtos;
  EmployeeWorkGroupIds: TVariantList
);
begin

  inherited Create;

  FPerformingStaffDtos := PerformingStaffDtos;
  FEmployeeWorkGroupIds := EmployeeWorkGroupIds;
  
end;

destructor TEmployeeChargePerformingUnitDto.Destroy;
begin

  FreeAndNil(FPerformingStaffDtos);
  FreeAndNil(FEmployeeWorkGroupIds);
  
  inherited;

end;

procedure TEmployeeChargePerformingUnitDto.SetEmployeeWorkGroupIds(
  const Value: TVariantList);
begin

  FreeAndNil(FEmployeeWorkGroupIds);
  
  FEmployeeWorkGroupIds := Value;

end;

procedure TEmployeeChargePerformingUnitDto.SetPerformingStaffDtos(
  const Value: TEmployeeStaffDtos);
begin

  FreeAndNil(FPerformingStaffDtos);
  
  FPerformingStaffDtos := Value;

end;

end.
