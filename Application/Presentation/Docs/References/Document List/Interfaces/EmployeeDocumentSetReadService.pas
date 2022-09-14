unit EmployeeDocumentSetReadService;

interface

uses

  ApplicationService,
  VariantListUnit,
  DocumentSetHolder,
  Classes,
  SysUtils;

type

//   Первое прриближение Options {
//      SortOptions,
//      FilterOptions,
//      Page {
//        Number: 5,
//        Count: 100
//    }
//   }

//  Текущий временный вариант
//  Options {
//    SelectedDocumentWorkCycleStages: TList
//  }


  IEmployeeDocumentSetReadOptions = interface

    function GetSelectedDocumentWorkCycleStageNames: TStrings;
    procedure SetSelectedDocumentWorkCycleStageNames(const Value: TStrings);

    property SelectedDocumentWorkCycleStageNames: TStrings
    read GetSelectedDocumentWorkCycleStageNames write SetSelectedDocumentWorkCycleStageNames;

  end;

  TEmployeeDocumentSetReadOptions = class (TInterfacedObject, IEmployeeDocumentSetReadOptions)

    private

      FSelectedDocumentWorkCycleStageNames: TStrings;

      function GetSelectedDocumentWorkCycleStageNames: TStrings;
      procedure SetSelectedDocumentWorkCycleStageNames(const Value: TStrings);

    public

      destructor Destroy; override;

      constructor Create; overload;
      constructor Create(SelectedDocumentWorkCycleStageNames: TStrings); overload;

      property SelectedDocumentWorkCycleStageNames: TStrings
      read GetSelectedDocumentWorkCycleStageNames write SetSelectedDocumentWorkCycleStageNames;

  end;


  IEmployeeDocumentSetReadService = interface (IApplicationService)

    function GetEmployeeDocumentSet(const EmployeeId: Variant; const Options: IEmployeeDocumentSetReadOptions = nil): TDocumentSetHolder;
    function GetEmployeeDocumentSubSetByIds(const EmployeeId: Variant; DocumentIds: array of Variant): TDocumentSetHolder; overload;
    function GetEmployeeDocumentSubSetByIds(const EmployeeId: Variant; const DocumentIds: TVariantList): TDocumentSetHolder; overload;
    
  end;
  
implementation

{ TEmployeeDocumentSetReadOptions }

constructor TEmployeeDocumentSetReadOptions.Create;
begin

  inherited;

  FSelectedDocumentWorkCycleStageNames := TStringList.Create;

end;

constructor TEmployeeDocumentSetReadOptions.Create(
  SelectedDocumentWorkCycleStageNames: TStrings);
begin

  inherited Create;

  FSelectedDocumentWorkCycleStageNames := SelectedDocumentWorkCycleStageNames;
  
end;

destructor TEmployeeDocumentSetReadOptions.Destroy;
begin
  FreeAndNil(FSelectedDocumentWorkCycleStageNames);
  inherited;
end;

function TEmployeeDocumentSetReadOptions.GetSelectedDocumentWorkCycleStageNames: TStrings;
begin

  Result := FSelectedDocumentWorkCycleStageNames;

end;

procedure TEmployeeDocumentSetReadOptions.SetSelectedDocumentWorkCycleStageNames(
  const Value: TStrings);
begin

  FreeAndNil(FSelectedDocumentWorkCycleStageNames);

  FSelectedDocumentWorkCycleStageNames := Value;
  
end;

end.
