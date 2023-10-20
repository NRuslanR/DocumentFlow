unit DocumentChargeSheetsFormViewModel;

interface

uses

  DocumentChargesFormViewModelUnit,
  SysUtils,
  Classes,
  DocumentChargeKindDto,
  DocumentChargeSetHolder,
  DocumentChargeSheetSetHolder,
  Disposable,
  DB;

type

  TDocumentChargeSheetsFormViewModel = class (TInterfacedObject, IDisposable)

    private

      function GetDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;

      procedure SetDocumentChargeSheetSetHolder(
        const Value: TDocumentChargeSheetSetHolder);

      function GetDocumentChargeKindDto: TDocumentChargeKindDto;
      function GetDocumentChargeSetHolder: TDocumentChargeSetHolder;

      procedure SetDocumentChargeKindDto(const Value: TDocumentChargeKindDto);
      procedure SetDocumentChargeSetHolder(const Value: TDocumentChargeSetHolder);

      procedure SetChargesFormViewModel(
        const Value: TDocumentChargesFormViewModel);

    protected

      FChargesFormViewModel: TDocumentChargesFormViewModel;
      FFreeChargesFormViewModel: IDisposable;

      FDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
      FFreeDocumentChargeSheetSetHolder: IDisposable;
      
    public

      destructor Destroy; override;

      constructor Create; overload;

      constructor Create(
        ChargesFormViewModel: TDocumentChargesFormViewModel;
        DocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder
      ); overload;

      property ChargesFormViewModel: TDocumentChargesFormViewModel
      read FChargesFormViewModel write SetChargesFormViewModel;
      
      property DocumentChargeKindDto: TDocumentChargeKindDto
      read GetDocumentChargeKindDto write SetDocumentChargeKindDto;
      
      property DocumentChargeSetHolder: TDocumentChargeSetHolder
      read GetDocumentChargeSetHolder write SetDocumentChargeSetHolder;

      property DocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder
      read GetDocumentChargeSheetSetHolder write SetDocumentChargeSheetSetHolder;

  end;

implementation

uses AbstractDataSetHolder;

{ TDocumentChargeSheetsFormViewModel }

constructor TDocumentChargeSheetsFormViewModel.Create;
begin

  inherited;
  
end;

constructor TDocumentChargeSheetsFormViewModel.Create(
  ChargesFormViewModel: TDocumentChargesFormViewModel;
  DocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder
);
begin

  inherited Create;

  Self.ChargesFormViewModel := ChargesFormViewModel;
  
  FDocumentChargeSheetSetHolder := DocumentChargeSheetSetHolder;
  
end;

destructor TDocumentChargeSheetsFormViewModel.Destroy;
begin

  inherited;

end;

function TDocumentChargeSheetsFormViewModel.GetDocumentChargeKindDto: TDocumentChargeKindDto;
begin

  Result := FChargesFormViewModel.DocumentChargeKindDto;

end;

function TDocumentChargeSheetsFormViewModel.GetDocumentChargeSetHolder: TDocumentChargeSetHolder;
begin

  Result := FChargesFormViewModel.DocumentChargeSetHolder;

end;

function TDocumentChargeSheetsFormViewModel.GetDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
begin

  Result := FDocumentChargeSheetSetHolder;

end;

procedure TDocumentChargeSheetsFormViewModel.SetChargesFormViewModel(
  const Value: TDocumentChargesFormViewModel);
begin

  if FChargesFormViewModel = Value then Exit;
  
  FChargesFormViewModel := Value;
  FFreeChargesFormViewModel := Value;
  
  if
    not Assigned(FChargesFormViewModel)
    or not Assigned(FChargesFormViewModel.DocumentChargeSetHolder)
    or not Assigned(FDocumentChargeSheetSetHolder)
  then Exit;

  if Assigned(FChargesFormViewModel.DocumentChargeSetHolder.DataSet)
  then begin

    FDocumentChargeSheetSetHolder.DataSet :=
      FChargesFormViewModel.DocumentChargeSetHolder.DataSet;

  end
  else begin

    FChargesFormViewModel.DocumentChargeSetHolder.DataSet :=
      FDocumentChargeSheetSetHolder.DataSet;

  end;

end;

procedure TDocumentChargeSheetsFormViewModel.SetDocumentChargeKindDto(
  const Value: TDocumentChargeKindDto);
begin

  FChargesFormViewModel.DocumentChargeKindDto := Value;
  
end;

procedure TDocumentChargeSheetsFormViewModel.SetDocumentChargeSetHolder(
  const Value: TDocumentChargeSetHolder);
begin

  FChargesFormViewModel.DocumentChargeSetHolder := Value;

  FDocumentChargeSheetSetHolder.ChargeSetHolder := Value;
  
end;

procedure TDocumentChargeSheetsFormViewModel.SetDocumentChargeSheetSetHolder(
  const Value: TDocumentChargeSheetSetHolder);
begin

  if FDocumentChargeSheetSetHolder = Value then Exit;

  FDocumentChargeSheetSetHolder := Value;
  FFreeDocumentChargeSheetSetHolder := Value;
  
  if
    not Assigned(FDocumentChargeSheetSetHolder)
    or not Assigned(FChargesFormViewModel)
  then Exit;

  if Assigned(FDocumentChargeSheetSetHolder.ChargeSetHolder)
  then begin

    FChargesFormViewModel.DocumentChargeSetHolder :=
      FDocumentChargeSheetSetHolder.ChargeSetHolder;

  end
  else begin

    FDocumentChargeSheetSetHolder.ChargeSetHolder :=
      FChargesFormViewModel.DocumentChargeSetHolder;
      
  end;

end;

end.
