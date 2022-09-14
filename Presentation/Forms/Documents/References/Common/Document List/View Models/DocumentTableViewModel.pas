unit DocumentTableViewModel;

interface

uses

  ColumnCellComparator,
  DefaultColumnCellComparator,
  DocumentSetHolder,
  SysUtils,
  Classes;

type

  TDocumentTableViewModel = class
      
    protected

      FDocumentSetHolder: TDocumentSetHolder;
      FFilterDocumentWorkCycleStageNames: TStrings;
      FColumnCellComparator: IColumnCellComparator;

      procedure SetDocumentSetHolder(const Value: TDocumentSetHolder);
      procedure SetFilterDocumentWorkCycleStageNames(const Value: TStrings);

    public

      destructor Destroy; override;
      constructor Create;

    published

      property DocumentSetHolder: TDocumentSetHolder
      read FDocumentSetHolder write SetDocumentSetHolder;

      property FilterDocumentWorkCycleStageNames: TStrings
      read FFilterDocumentWorkCycleStageNames
      write SetFilterDocumentWorkCycleStageNames;

      property ColumnCellComparator: IColumnCellComparator
      read FColumnCellComparator write FColumnCellComparator;
      
  end;

  TDocumentTableViewModelClass = class of TDocumentTableViewModel;
  
implementation

{ TDocumentTableViewModel }

constructor TDocumentTableViewModel.Create;
begin

  inherited;

  FilterDocumentWorkCycleStageNames := TStringList.Create;
  
end;

destructor TDocumentTableViewModel.Destroy;
begin

  FreeAndNil(FFilterDocumentWorkCycleStageNames);
  FreeAndNil(FDocumentSetHolder);
  
  inherited;

end;

procedure TDocumentTableViewModel.SetDocumentSetHolder(
  const Value: TDocumentSetHolder);
begin

  if FDocumentSetHolder = Value then
    Exit;

  FreeAndNil(FDocumentSetHolder);
  
  FDocumentSetHolder := Value;

end;

procedure TDocumentTableViewModel.SetFilterDocumentWorkCycleStageNames(
  const Value: TStrings);
begin

  if FFilterDocumentWorkCycleStageNames = Value then
    Exit;

  FreeAndNil(FFilterDocumentWorkCycleStageNames);
  
  FFilterDocumentWorkCycleStageNames := Value;

end;

end.
