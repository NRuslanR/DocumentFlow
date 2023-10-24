unit StandardDocumentChargeSheetOverlappingPerformingService;

interface

uses

  DocumentChargeSheetOverlappingPerformingService,
  Employee,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetFinder,
  EmployeeIsSameAsOrDeputySpecification,
  DocumentChargeSheetPerformingService,
  DocumentChargeSheet,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetOverlappingPerformingService =
    class (
      TAbstractDocumentChargeSheetPerformingService,
      IDocumentChargeSheetOverlappingPerformingService
    )

      protected

        FEmployeeIsSameAsOrDeputySpecification:
          IEmployeeIsSameAsOrDeputySpecification;

        FDocumentChargeSheetFinder: IDocumentChargeSheetFinder;

      public

        constructor Create(

          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification;

          DocumentChargeSheetFinder: IDocumentChargeSheetFinder

        );

        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): IDocumentChargeSheets; virtual;

        function PerformChargeSheetAsOverlapping(
          ChargeSheet: IDocumentChargeSheet;
          Performer: TEmployee;
          const PerformingDate: TDateTime = 0
        ): IDocumentChargeSheets; virtual;

    end;

implementation

uses

  AuxCollectionFunctionsUnit,
  AuxDebugFunctionsUnit,
  IDomainObjectListUnit;
  
type

  TDocumentChargeSheetQueue = class

    private

      type

        TChargeSheetEntry = class

          ChargeSheet: IDocumentChargeSheet;

          constructor Create(ChargeSheet: IDocumentChargeSheet);
          
        end;
        
    private

      FChargeSheetList: TList;

    public

      destructor Destroy; override;
      constructor Create;

      procedure EnqueueChargeSheet(ChargeSheet: IDocumentChargeSheet);
      function DequeueChargeSheet: IDocumentChargeSheet;
      function IsEmpty: Boolean;

  end;
  
{ TStandardDocumentChargeSheetOverlappingPerformingService }

constructor TStandardDocumentChargeSheetOverlappingPerformingService.Create(
  EmployeeIsSameAsOrDeputySpecification:
    IEmployeeIsSameAsOrDeputySpecification;

  DocumentChargeSheetFinder: IDocumentChargeSheetFinder
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputySpecification :=
    EmployeeIsSameAsOrDeputySpecification;

  FDocumentChargeSheetFinder := DocumentChargeSheetFinder;

end;

function TStandardDocumentChargeSheetOverlappingPerformingService.
  PerformChargeSheetAsOverlapping(
    ChargeSheet: IDocumentChargeSheet;
    Performer: TEmployee;
    const PerformingDate: TDateTime
  ): IDocumentChargeSheets;
begin

  Result := PerformChargeSheet(ChargeSheet, Performer, PerformingDate);

end;

function TStandardDocumentChargeSheetOverlappingPerformingService.PerformChargeSheet(
  ChargeSheet: IDocumentChargeSheet;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): IDocumentChargeSheets;
var
    ChargeSheetObj: TDocumentChargeSheet;
    FreeSubordinateDocumentChargeSheets: IDomainObjectList;
    AllSubordinateDocumentChargeSheets: TDocumentChargeSheets;

    OverlappingChargeSheetQueue: TDocumentChargeSheetQueue;
    CurrentOverlappingChargeSheet: IDocumentChargeSheet;
    CurrentOverlappableChargeSheet: IDocumentChargeSheet;

    FreeOverlappableChargeSheets: IDomainObjectList;
    OverlappableChargeSheets: TDocumentChargeSheets;

    I: Integer;

    PerformedDocumentChargeSheets: TDocumentChargeSheets;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj.PerformBy(Employee, PerformingDateTime);

  PerformedDocumentChargeSheets := ChargeSheetObj.ListType.Create;

  Result := PerformedDocumentChargeSheets;

  PerformedDocumentChargeSheets.AddDocumentChargeSheet(ChargeSheetObj);

  AllSubordinateDocumentChargeSheets :=
    FDocumentChargeSheetFinder.FindAllSubordinateChargeSheetsFor(
      ChargeSheetObj
    );

  if not Assigned(AllSubordinateDocumentChargeSheets) then Exit;
  
  FreeSubordinateDocumentChargeSheets := AllSubordinateDocumentChargeSheets;
  
  OverlappingChargeSheetQueue := TDocumentChargeSheetQueue.Create;
  
  try

    OverlappingChargeSheetQueue.EnqueueChargeSheet(ChargeSheetObj);

    while not OverlappingChargeSheetQueue.IsEmpty do begin

      CurrentOverlappingChargeSheet :=
        OverlappingChargeSheetQueue.DequeueChargeSheet;

      OverlappableChargeSheets :=
        AllSubordinateDocumentChargeSheets.FindChargeSheetsByTopLevelChargeSheet(
          CurrentOverlappingChargeSheet.Identity
        );

      FreeOverlappableChargeSheets := OverlappableChargeSheets;

      for I := 0 to OverlappableChargeSheets.Count - 1 do begin

        if OverlappableChargeSheets[I].IsPerformed then Continue;
        
        OverlappableChargeSheets[I].PerformAsOverlappedIfPossible(
          CurrentOverlappingChargeSheet, Employee, PerformingDateTime
        );

        PerformedDocumentChargeSheets.AddDocumentChargeSheet(
          OverlappableChargeSheets[I]
        );

        OverlappingChargeSheetQueue.EnqueueChargeSheet(
          OverlappableChargeSheets[I]
        );
        
      end;

    end;

  finally

    FreeAndNil(OverlappingChargeSheetQueue);

  end;

end;

{ TDocumentChargeSheetQueue.TChargeSheetEntry }

constructor TDocumentChargeSheetQueue.TChargeSheetEntry.Create(
  ChargeSheet: IDocumentChargeSheet
);
begin

  inherited Create;

  Self.ChargeSheet := ChargeSheet;

end;

{ TDocumentChargeSheetQueue }

constructor TDocumentChargeSheetQueue.Create;
begin

  inherited Create;

  FChargeSheetList := TList.Create;
  
end;

function TDocumentChargeSheetQueue.DequeueChargeSheet: IDocumentChargeSheet;
var ChargeSheetEntry: TChargeSheetEntry;
begin

  ChargeSheetEntry := TChargeSheetEntry(FChargeSheetList.First);

  Result := ChargeSheetEntry.ChargeSheet;

  FChargeSheetList.Extract(ChargeSheetEntry);

end;

destructor TDocumentChargeSheetQueue.Destroy;
begin

  FreeListWithItems(FChargeSheetList);
  inherited;

end;

procedure TDocumentChargeSheetQueue.EnqueueChargeSheet(
  ChargeSheet: IDocumentChargeSheet
);
begin

  FChargeSheetList.Add(TChargeSheetEntry.Create(ChargeSheet));

end;

function TDocumentChargeSheetQueue.IsEmpty: Boolean;
begin

  Result := FChargeSheetList.Count = 0;
  
end;

end.
