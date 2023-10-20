unit unPersonnelOrderApprovingsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentApprovingsFrameUnit, StdCtrls, ExtCtrls,
  PersonnelOrderApproverSetReadService, EmployeeSetHolder,
  DocumentApprovingCycleViewModel;

type

  TPersonnelOrderApprovingsFrame = class(TDocumentApprovingsFrame)

  private

    function CreateNewApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    
  public

    procedure CreateNewApprovingCycleForPersonnelOrderSubKind(
      const PersonnelOrderSubKindId: Variant
    );
    
  end;

var
  PersonnelOrderApprovingsFrame: TPersonnelOrderApprovingsFrame;

implementation

uses

  DocumentApprovingCycleDTO,
  Disposable,
  DocumentApprovingControlAppService,
  DocumentCardFormViewModelMapper,
  DocumentCardFormViewModelMapperFactory,
  DocumentApprovingsFormViewModelMapper,
  DocumentCardFormViewModelMapperFactories,
  ApplicationServiceRegistries,
  PresentationServiceRegistry,
  PersonnelOrderPresentationServiceRegistry,
  DocumentBusinessProcessServiceRegistry;
  
{$R *.dfm}

{ TPersonnelOrderApprovingsFrame }

procedure TPersonnelOrderApprovingsFrame.CreateNewApprovingCycleForPersonnelOrderSubKind(
  const PersonnelOrderSubKindId: Variant
);
var
    PersonnelOrderApproverSetReadService: IPersonnelOrderApproverSetReadService;
    PersonnelOrderSubKindApproverSetHolder: TEmployeeSetHolder;
    FreePersonnelOrderSubKindApproverSetHolder: IDisposable;
    NewApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  PersonnelOrderApproverSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetPersonnelOrderPresentationServiceRegistry
            .GetPersonnelOrderApproverSetReadService;

  PersonnelOrderSubKindApproverSetHolder :=
    PersonnelOrderApproverSetReadService.GetApproverSetForPersonnelOrderSubKind(
      PersonnelOrderSubKindId
    );

  FreePersonnelOrderSubKindApproverSetHolder := PersonnelOrderSubKindApproverSetHolder;

  if FDocumentApprovingCyclesReferenceForm.SelectNewApprovingCycleRecord
  then begin

    FDocumentApprovingCyclesReferenceForm.RemoveFocusedDocumentApprovingCycleRecord;

  end;
  
  if
    not Assigned(PersonnelOrderSubKindApproverSetHolder)
    or PersonnelOrderSubKindApproverSetHolder.IsEmpty
  then Exit;

  //BeginUpdate;

  try

    NewApprovingCycleViewModel := CreateNewApprovingCycleViewModel;
      
    AddDocumentApprovingCycleWithApprovers(
      NewApprovingCycleViewModel, PersonnelOrderSubKindApproverSetHolder
    );

  finally

    //EndUpdate;
    
  end;

end;

{ refactor: выделить создание моделей цикла согласования в отдельные фабрики }
function TPersonnelOrderApprovingsFrame.CreateNewApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
var
    CardFormViewModelMapper: TDocumentCardFormViewModelMapper;
    CardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
    DocumentApprovingControlAppService: IDocumentApprovingControlAppService;
    DocumentApprovingCycleDto: TDocumentApprovingCycleDTO;
    ApprovingsFormViewModelMapper: TDocumentApprovingsFormViewModelMapper;
begin

  DocumentApprovingCycleDto := nil;
  CardFormViewModelMapperFactory := nil;
  CardFormViewModelMapper := nil;

  try
                            
    CardFormViewModelMapperFactory :=
      TDocumentCardFormViewModelMapperFactories
        .Current
          .CreateDocumentCardFormViewModelMapperFactory(UIDocumentKind);

    CardFormViewModelMapper :=
      CardFormViewModelMapperFactory.CreateDocumentCardFormViewModelMapper;
      
    ApprovingsFormViewModelMapper :=
      CardFormViewModelMapper.DocumentApprovingsFormViewModelMapper;

    if VarIsNull(DocumentId) then
      Result := ApprovingsFormViewModelMapper.CreateNewDocumentApprovingCycleViewModel

    else begin

      DocumentApprovingControlAppService :=
        TApplicationServiceRegistries
          .Current
            .GetDocumentBusinessProcessServiceRegistry
              .GetDocumentApprovingControlAppService(ServiceDocumentKind);
              
      DocumentApprovingCycleDto :=
        DocumentApprovingControlAppService.GetInfoForNewDocumentApprovingCycle(
          DocumentId, WorkingEmployeeId
        );

      Result :=
        ApprovingsFormViewModelMapper
          .MapDocumentApprovingCycleViewModelFrom(DocumentApprovingCycleDto);

    end;

  finally

    FreeAndNil(DocumentApprovingCycleDto);
    FreeAndNil(CardFormViewModelMapperFactory);
    FreeAndNil(CardFormViewModelMapper);
    
  end;

end;

end.
