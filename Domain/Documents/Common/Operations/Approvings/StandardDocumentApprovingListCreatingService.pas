unit StandardDocumentApprovingListCreatingService;

interface

uses

  DocumentApprovingsCollector,
  DocumentApprovingListCreatingService,
  DocumentApprovingList,
  DocumentApprovings,
  DocumentApprovingsPicker,
  IDocumentUnit,
  DepartmentEmployeeDistributionService,
  Document,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentApprovingPartition = (apViseing, apStandard);
  TDocumentApprovingPartitions = set of TDocumentApprovingPartition;

  TStandardDocumentApprovingListCreatingService =
    class (TInterfacedObject, IDocumentApprovingListCreatingService)

      protected

        FDocumentApprovingsCollector: IDocumentApprovingsCollector;
        FDocumentApprovingsPicker: IDocumentApprovingsPicker;
        FDepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService;

      protected

        function PartitionDocumentApprovings(
          Document: IDocument;
          DocumentApprovings: TDocumentApprovings;
          const Partitions: TDocumentApprovingPartitions
        ): TDocumentApprovingLists;

      protected

        function CreateDocumentApprovingListFrom(
          const ListTitle: String;
          const ListKind: TDocumentApprovingListKind;
          DocumentApprovings: TDocumentApprovings
        ): TDocumentApprovingList;
        
      public

        constructor Create(
          DocumentApprovingsCollector: IDocumentApprovingsCollector;
          DocumentApprovingsPicker: IDocumentApprovingsPicker;
          DepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService
        );

        function CreateDocumentApprovingLists(const DocumentId: Variant): TDocumentApprovingLists; virtual;

    end;

implementation

uses

  IDomainObjectUnit,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  AuxDebugFunctionsUnit;

{ TStandardDocumentApprovingListCreatingService }

constructor TStandardDocumentApprovingListCreatingService.Create(
  DocumentApprovingsCollector: IDocumentApprovingsCollector;
  DocumentApprovingsPicker: IDocumentApprovingsPicker;
  DepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService
);
begin

  inherited Create;

  FDocumentApprovingsCollector := DocumentApprovingsCollector;
  FDocumentApprovingsPicker := DocumentApprovingsPicker;
  FDepartmentEmployeeDistributionService := DepartmentEmployeeDistributionService;

end;

function TStandardDocumentApprovingListCreatingService.
  CreateDocumentApprovingLists(const DocumentId: Variant): TDocumentApprovingLists;

var
    DocumentApprovingCollectingResult: TDocumentApprovingCollectingResult;
    Free: IDomainObjectBase;

    PickedDocumentApprovings: TDocumentApprovings;
    FreePickedDocumentApprovings: IDomainObjectBaseList;
begin

  DocumentApprovingCollectingResult :=
    FDocumentApprovingsCollector.CollectDocumentApprovings(DocumentId);

  if not Assigned(DocumentApprovingCollectingResult) then begin

    Result := nil;
    Exit;

  end;

  Free := DocumentApprovingCollectingResult;

  PickedDocumentApprovings :=
    FDocumentApprovingsPicker.PickDocumentApprovingsFrom(
      DocumentApprovingCollectingResult.CurrentDocumentApprovings,
      DocumentApprovingCollectingResult.DocumentApprovingCycleResults
    );

  FreePickedDocumentApprovings := PickedDocumentApprovings;

  Result :=
    PartitionDocumentApprovings(
      DocumentApprovingCollectingResult.Document,
      PickedDocumentApprovings,
      [apViseing, apStandard]
    );

end;

{ refactor:
  extract to separate class DocumentApprovingPartitioner
  interface of that is a one method that returns of the DocumentApprovingPartitions without any arguments
  where DocumentApprovingPartition interface:
    Name of this partition,
    Order (priority) in whole list of the partitions,
    appropriate document approvings
}
function TStandardDocumentApprovingListCreatingService.PartitionDocumentApprovings(
  Document: IDocument;
  DocumentApprovings: TDocumentApprovings;
  const Partitions: TDocumentApprovingPartitions
): TDocumentApprovingLists;
var
    DocumentViseings: TDocumentApprovings;
    FreeDocumentViseings: IDomainObjectBaseList;
    FreeDocumentApprovings: IDomainObjectBaseList;

    function CreateDocumentViseingsPartition(Approvings: TDocumentApprovings): TDocumentApprovings;
    var
        Approvers: TEmployees;
        FreeApprovers: IDomainObjectBaseList;

        Visers: TEmployees;
        FreeVisers: IDomainObjectBaseList;
    begin

      Approvers := Approvings.FetchApprovers;

      FreeApprovers := Approvers;

      Visers :=
        FDepartmentEmployeeDistributionService
          .GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
            Approvers, Document.Author
          );

      if not Assigned(Visers) or Visers.IsEmpty then begin

        Result := nil;
        Exit;
        
      end;
      
      FreeVisers := Visers;

      Result := DocumentApprovings.FindByApprovers(Visers);
      
    end;

    function CreateStandardDocumentApprovingsPartition(Approvings: TDocumentApprovings): TDocumentApprovings;
    begin

      Result := Approvings;
      
    end;

begin

  Result := TDocumentApprovingLists.Create;

  try

    if DocumentApprovings.IsEmpty or (Partitions = []) then Exit;

    if apViseing in Partitions then begin

      DocumentViseings := CreateDocumentViseingsPartition(DocumentApprovings);

      if Assigned(DocumentViseings) and not DocumentViseings.IsEmpty then begin

        FreeDocumentViseings := DocumentViseings;

        Result.Add(CreateDocumentApprovingListFrom('Завизировано:', alkViseing, DocumentViseings));

        DocumentApprovings := TDocumentApprovings(DocumentApprovings.Exclude(DocumentViseings));

      end;

    end;

    if apStandard in Partitions then begin

      DocumentApprovings := CreateStandardDocumentApprovingsPartition(DocumentApprovings);

      if Assigned(DocumentApprovings) and not DocumentApprovings.IsEmpty then begin

        FreeDocumentApprovings := DocumentApprovings;

        Result.Add(CreateDocumentApprovingListFrom('Согласовано:', alkApproving, DocumentApprovings));

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentApprovingListCreatingService.CreateDocumentApprovingListFrom(
  const ListTitle: String;
  const ListKind: TDocumentApprovingListKind;
  DocumentApprovings: TDocumentApprovings
): TDocumentApprovingList;
var
    DocumentApproving: TDocumentApproving;
begin

  Result := TDocumentApprovingList.Create;

  try

    Result.Title := ListTitle;
    Result.Kind := ListKind;

    for DocumentApproving in DocumentApprovings do
      Result.AddRecordFor(DocumentApproving.Approver, DocumentApproving.PerformingResult);
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
