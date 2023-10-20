unit DocumentsReferenceViewModelFactory;

interface

uses

  UIDocumentKinds,
  DocumentSetHolder,
  DocumentKinds,
  StandardUIDocumentKindMapper,
  DocumentTableViewModel,
  DocumentKindWorkCycleColors,
  DocumentsReferenceViewModel,
  ColumnCellComparator,
  DocumentKindWorkCycleInfoDto,
  ServiceNoteNumberColumnCellComparator,
  DefaultColumnCellComparator,
  SysUtils,
  Classes;

  
type

  TDocumentsReferenceViewModelFactory = class

    private

      FStandardUIDocumentKindMapper: TStandardUIDocumentKindMapper;

      function CreateDocumentTableViewModel(
        const UIDocumentKind: TUIDocumentKindClass;
        const DocumentSetHolder: TDocumentSetHolder;
        const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos
      ): TDocumentTableViewModel;

      function CreateDocumentKindWorkCycleColors(
        const UIDocumentKind: TUIDocumentKindClass;
        const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos
      ): TDocumentKindWorkCycleColors;

    private

      function CreateDocumentsReferenceColumnCellComparator(
        const UIDocumentKind: TUIDocumentKindClass
      ): IColumnCellComparator; 

    public

      destructor Destroy; override;
      constructor Create;
      
      function CreateDocumentsReferenceViewModelFor(
        const UIDocumentKind: TUIDocumentKindClass;
        const DocumentSetHolder: TDocumentSetHolder;
        const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos;
        const SelectedDocumentWorkCycleStageNames: TStrings
      ): TDocumentsReferenceViewModel; overload;

  end;

implementation

{ TDocumentsReferenceViewModelFactory }

destructor TDocumentsReferenceViewModelFactory.Destroy;
begin

  FreeAndNil(FStandardUIDocumentKindMapper);
  
  inherited;

end;

constructor TDocumentsReferenceViewModelFactory.Create;
begin

  inherited;

  FStandardUIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;
  
end;

function TDocumentsReferenceViewModelFactory.
  CreateDocumentsReferenceViewModelFor(
    const UIDocumentKind: TUIDocumentKindClass;
    const DocumentSetHolder: TDocumentSetHolder;
    const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos;
    const SelectedDocumentWorkCycleStageNames: TStrings
  ): TDocumentsReferenceViewModel;
var
    DocumentTableViewModel: TDocumentTableViewModel;
    DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
    DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;

    function CreateStringsCopy(Strings: TStrings): TStrings;
    begin

      Result := TStringList.Create;

      TStringList(Result).Assign(Strings);

    end;

begin

  DocumentTableViewModel := nil; DocumentKindWorkCycleColors := nil;

  try

    DocumentTableViewModel :=
      CreateDocumentTableViewModel(
        UIDocumentKind, DocumentSetHolder, DocumentKindWorkCycleInfoDtos
      );

    DocumentKindWorkCycleColors :=
      CreateDocumentKindWorkCycleColors(
        UIDocumentKind, DocumentKindWorkCycleInfoDtos
      );

    DocumentKindWorkCycleInfoDto :=
      DocumentKindWorkCycleInfoDtos.FindByDocumentKind(
        FStandardUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
      );

    Result :=
      TDocumentsReferenceViewModel.Create(
        DocumentTableViewModel,
        DocumentKindWorkCycleColors,
        DocumentKindWorkCycleInfoDto,
        CreateStringsCopy(SelectedDocumentWorkCycleStageNames)
      );

  except

    FreeAndNil(DocumentTableViewModel);
    FreeAndNil(DocumentKindWorkCycleColors);

    Raise;

  end;

end;

function TDocumentsReferenceViewModelFactory.CreateDocumentTableViewModel(
  const UIDocumentKind: TUIDocumentKindClass;
  const DocumentSetHolder: TDocumentSetHolder;
  const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos
): TDocumentTableViewModel;
var
  DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
begin

  Result := TDocumentTableViewModel.Create;

  Result.DocumentSetHolder := DocumentSetHolder;

  DocumentKindWorkCycleInfoDto :=
    DocumentKindWorkCycleInfoDtos.FindByDocumentKind(
      FStandardUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
    );

  with
    Result.FilterDocumentWorkCycleStageNames,
    DocumentKindWorkCycleInfoDto
  do begin

    if DocumentCreatedStageInfo.StageNumber <> -1 then
      Add(DocumentCreatedStageInfo.StageName);

    if DocumentApprovingStageInfo.StageNumber <> -1 then
      Add(DocumentApprovingStageInfo.StageName);

    if DocumentApprovedStageInfo.StageNumber <> -1 then
      Add(DocumentApprovedStageInfo.StageName);

    if DocumentNotApprovedStageInfo.StageNumber <> -1 then
      Add(DocumentNotApprovedStageInfo.StageName);

    if DocumentSigningStageInfo.StageNumber <> -1 then
      Add(DocumentSigningStageInfo.StageName);

    if DocumentSigningRejectedStageInfo.StageNumber <> -1 then
      Add(DocumentSigningRejectedStageInfo.StageName);

    if DocumentPerformingStageInfo.StageNumber <> -1 then
      Add(DocumentPerformingStageInfo.StageName);

    if DocumentPerformedStageInfo.StageNumber <> -1 then
      Add(DocumentPerformedStageInfo.StageName);

  end;

  Result.ColumnCellComparator :=
    CreateDocumentsReferenceColumnCellComparator(UIDocumentKind);

end;

function TDocumentsReferenceViewModelFactory.CreateDocumentKindWorkCycleColors(
  const UIDocumentKind: TUIDocumentKindClass;
  const DocumentKindWorkCycleInfoDtos: TDocumentKindWorkCycleInfoDtos
): TDocumentKindWorkCycleColors;
begin

  Result := TDocumentKindWorkCycleColors.Create(DocumentKindWorkCycleInfoDtos);

end;

function TDocumentsReferenceViewModelFactory.
  CreateDocumentsReferenceColumnCellComparator(
    const UIDocumentKind: TUIDocumentKindClass
  ): IColumnCellComparator;
begin

  if
    (UIDocumentKind = TUIOutcomingServiceNoteKind) or
    (UIDocumentKind = TUIIncomingServiceNoteKind) or
    (UIDocumentKind = TUIApproveableServiceNoteKind)
  then
    Result := TServiceNoteNumberColumnCellComparator.Create

  else Result := TDefaultColumnCellComparator.Create;
  
end;

end.
