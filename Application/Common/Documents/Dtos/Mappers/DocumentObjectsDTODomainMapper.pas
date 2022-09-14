unit DocumentObjectsDTODomainMapper;

interface

uses

  Document,
  IDocumentUnit,
  Employee,
  DocumentSignings,
  DocumentCharges,
  DocumentRelationsUnit,
  DocumentFileUnit,
  SysUtils,
  DocumentFullInfoDTO,
  DocumentChargesInfoDTODomainMapper,
  NewDocumentInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentApprovings,
  DocumentCreatingService,
  DocumentResponsibleInfoDTOMapper,
  EmployeeDocumentWorkingRules,
  IEmployeeRepositoryUnit,
  IDomainObjectUnit,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit,
  IDomainObjectListUnit,
  Classes;

type

  TDocumentObjects = class

    private

      FDocument: TDocument;
      FFreeDocument: IDocument;
      
      FDocumentRelations: TDocumentRelations;
      FFreeDocumentRelations: IDomainObjectBase;

      FDocumentFiles: TDocumentFiles;
      FFreeDocumentFiles: IDomainObjectBaseList;
      
      FDocumentResponsible: TEmployee;
      FFreeDocumentResponsible: IDomainObjectBase;

      procedure SetDocument(Document: TDocument);
      procedure SetDocumentFiles(const Value: TDocumentFiles);
      procedure SetDocumentRelations(const Value: TDocumentRelations);
      procedure SetDocumentResponsible(const Value: TEmployee);
      
    public

      property Document: TDocument read FDocument write SetDocument;

      property DocumentResponsible: TEmployee
      read FDocumentResponsible write SetDocumentResponsible;

      property DocumentRelations: TDocumentRelations
      read FDocumentRelations write SetDocumentRelations;

      property DocumentFiles: TDocumentFiles
      read FDocumentFiles write SetDocumentFiles;

  end;

  TDocumentObjectsDTODomainMapper = class

    protected

      FEmployeeRepository: IEmployeeRepository;
      FDocumentCreatingService: IDocumentCreatingService;
      FChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
      FDocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;
      
      function CreateDocumentObjectsInstance: TDocumentObjects; virtual;
      function CreateDocumentInstanceFor(const RequestingEmployee: TEmployee): IDocument; virtual;
      function CreateDocumentRelationsInstance: TDocumentRelations; virtual;
      function CreateDocumentFilesInstance: TDocumentFiles; virtual;

    public

      constructor Create(
        EmployeeRepository: IEmployeeRepository;
        DocumentCreatingService: IDocumentCreatingService;
        ChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
        DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper
      ); overload;

      function MapNewDocumentObjectsBy(
        NewDocumentInfoDTO: TNewDocumentInfoDTO;
        CreatingEmployee: TEmployee
      ): TDocumentObjects; virtual;

      function MapChangedDocumentObjectsBy(
        ChangedDocumentInfoDTO: TChangedDocumentInfoDTO;
        SourceDocument: IDocument;
        ChangingEmployee: TEmployee
      ): TDocumentObjects; virtual;

    public

      function MapNewDocumentFrom(
        DocumentDTO: TDocumentDTO;
        RequestingEmployee: TEmployee
      ): IDocument; virtual;

      function MapChangedDocumentFrom(
        Document: IDocument;
        ChangingEmployee: TEmployee;
        ChangedDocumentDTO: TChangedDocumentDTO
      ): IDocument; virtual;

    public

      procedure MapAndAssignChargesToDocument(
        DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
        Document: IDocument
      );

      procedure ChangeDocumentChargesFrom(
        Document: IDocument;
        ChangedChargesInfoDTO: TDocumentChargesInfoDTO
      );

      procedure RemoveDocumentChargesFrom(
        Document: IDocument;
        RemoveableChargesInfoDTO: TDocumentChargesInfoDTO
      );

    public

      procedure MapAndAssignApprovingsToDocument(
        DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
        Document: IDocument;
        RequestingEmployee: TEmployee
      );

      procedure ChangeDocumentApprovingsFrom(
        DocumentApprovingsChangesInfoDTO: TDocumentApprovingsInfoDTO;
        Document: IDocument;
        ChangingEmployee: TEmployee
      );

    public

      procedure MapAndAssignSigningsToDocument(
        DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO;
        Document: IDocument
      );

      procedure ChangeDocumentSigningsFrom(
        Document: IDocument;
        SigningsInfoDTO: TDocumentSigningsInfoDTO
      );

    public

      function MapDocumentRelationsFrom(
        DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO
      ): TDocumentRelations; virtual;

      function MapDocumentFilesFrom(
        DocumentFilesInfoDTO: TDocumentFilesInfoDTO
      ): TDocumentFiles; virtual;

    public

      property EmployeeRepository: IEmployeeRepository
      read FEmployeeRepository write FEmployeeRepository;

  end;

  TDocumentObjectsDTODomainMapperClass =
    class of TDocumentObjectsDTODomainMapper;
  
implementation

uses

  Variants,
  VariantListUnit,
  DocumentRuleRegistry,
  AuxDebugFunctionsUnit,
  DocumentChargeInterface,
  AuxCollectionFunctionsUnit;

{ TDocumentObjectsDTODomainMapper }

procedure TDocumentObjectsDTODomainMapper.ChangeDocumentChargesFrom(
  Document: IDocument;
  ChangedChargesInfoDTO: TDocumentChargesInfoDTO
);
var
    ChangedCharges: IDocumentCharges;
begin

  if IsNotAssignedOrEmpty(ChangedChargesInfoDTO) then Exit;
  
  ChangedCharges :=
    FChargesInfoDTODomainMapper.MapDocumentChargesFrom(ChangedChargesInfoDTO, Document);

  Document.ChangeCharges(ChangedCharges);

end;

constructor TDocumentObjectsDTODomainMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentCreatingService: IDocumentCreatingService;
  ChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;
  DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FDocumentCreatingService := DocumentCreatingService;
  FChargesInfoDTODomainMapper := ChargesInfoDTODomainMapper;
  FDocumentResponsibleInfoDTOMapper := DocumentResponsibleInfoDTOMapper;
  
end;

function TDocumentObjectsDTODomainMapper.
  CreateDocumentObjectsInstance: TDocumentObjects;
begin

  Result := TDocumentObjects.Create;

end;

function TDocumentObjectsDTODomainMapper.CreateDocumentFilesInstance: TDocumentFiles;
begin

  Result := TDocumentFiles.Create;

end;

function TDocumentObjectsDTODomainMapper.
  CreateDocumentInstanceFor(const RequestingEmployee: TEmployee): IDocument;
begin

  Result :=
    FDocumentCreatingService.CreateDocumentInstanceForEmployee(RequestingEmployee);
  
end;

function TDocumentObjectsDTODomainMapper.CreateDocumentRelationsInstance: TDocumentRelations;
begin

  Result := TDocumentRelations.Create;

end;

function TDocumentObjectsDTODomainMapper.MapNewDocumentFrom(
  DocumentDTO: TDocumentDTO;
  RequestingEmployee: TEmployee
): IDocument;
var NewDocument: TDocument;
begin

  Result := CreateDocumentInstanceFor(RequestingEmployee);

  NewDocument := Result.Self as TDocument;

  with DocumentDTO do begin

    NewDocument.EditingEmployee := RequestingEmployee;
    
    NewDocument.Number := Number;
    NewDocument.Name := Name;
    NewDocument.DocumentDate := DocumentDate;
    NewDocument.CreationDate := CreationDate;
    NewDocument.Content := Content;
    NewDocument.Note := Note;
    NewDocument.ProductCode := ProductCode;
    NewDocument.IsSelfRegistered := IsSelfRegistered;
    NewDocument.ResponsibleId := ResponsibleInfoDTO.Id;

    MapAndAssignApprovingsToDocument(
      DocumentDTO.ApprovingsInfoDTO,
      Result,
      RequestingEmployee
    );
    
    MapAndAssignSigningsToDocument(
      DocumentDTO.SigningsInfoDTO,
      Result
    );

    MapAndAssignChargesToDocument(
      DocumentDTO.ChargesInfoDTO,
      Result
    );

  end;

end;

function TDocumentObjectsDTODomainMapper.MapChangedDocumentFrom(
  Document: IDocument;
  ChangingEmployee: TEmployee;
  ChangedDocumentDTO: TChangedDocumentDTO
): IDocument;
var
    AddedDocumentChargeInfoDTO: TDocumentChargeInfoDTO;
    ChangeableDocument: TDocument;
begin

  ChangeableDocument := Document.Self as TDocument;
  
  ChangeableDocument.EditingEmployee := ChangingEmployee;

  ChangeableDocument.Number := ChangedDocumentDTO.Number;
  ChangeableDocument.Name := ChangedDocumentDTO.Name;
  ChangeableDocument.Content := ChangedDocumentDTO.Content;
  ChangeableDocument.DocumentDate := ChangedDocumentDTO.DocumentDate;
  ChangeableDocument.CreationDate := ChangedDocumentDTO.CreationDate;
  ChangeableDocument.Note := ChangedDocumentDTO.Note;
  ChangeableDocument.ProductCode := ChangedDocumentDTO.ProductCode;
  ChangeableDocument.IsSelfRegistered := ChangedDocumentDTO.IsSelfRegistered;

  if Assigned(ChangedDocumentDTO.ResponsibleInfoDTO) then begin

    ChangeableDocument.ResponsibleId :=
      ChangedDocumentDTO.ResponsibleInfoDTO.Id;

  end;

  if Assigned(ChangedDocumentDTO.ApprovingsInfoDTO) then
    Document.RemoveAllApprovers(ChangingEmployee);

  if Assigned(ChangedDocumentDTO.ChargesChangesInfoDTO) then begin

    RemoveDocumentChargesFrom(
      Document,
      ChangedDocumentDTO.ChargesChangesInfoDTO.RemovedDocumentChargesInfoDTO
    );
    
  end;

  if Assigned(ChangedDocumentDTO.SigningsInfoDTO) then begin

    ChangeDocumentSigningsFrom(
      Document,
      ChangedDocumentDTO.SigningsInfoDTO
    );

  end;
  
  if Assigned(ChangedDocumentDTO.ApprovingsInfoDTO) then begin

    MapAndAssignApprovingsToDocument(
      ChangedDocumentDTO.ApprovingsInfoDTO,
      Document,
      ChangingEmployee
    );

  end;

  if Assigned(ChangedDocumentDTO.ChargesChangesInfoDTO) then begin

    MapAndAssignChargesToDocument(
      ChangedDocumentDTO.ChargesChangesInfoDTO.AddedDocumentChargesInfoDTO,
      Document
    );

    ChangeDocumentChargesFrom(
      Document,
      ChangedDocumentDTO.ChargesChangesInfoDTO.ChangedDocumentChargesInfoDTO
    );

  end;

  Result := Document;
  
end;

procedure TDocumentObjectsDTODomainMapper.RemoveDocumentChargesFrom(
  Document: IDocument;
  RemoveableChargesInfoDTO: TDocumentChargesInfoDTO
);
var
    PerformerIds: TVariantList;
    Performers: TEmployees;
    FreePerformers: IDomainObjectBaseList;
begin

  if IsNotAssignedOrEmpty(RemoveableChargesInfoDTO) then Exit;
  
  PerformerIds := RemoveableChargesInfoDTO.ExtractPerformerIds;

  try

    Performers := FEmployeeRepository.FindEmployeesByIdentities(PerformerIds);

    FreePerformers := Performers;

    Document.RemoveChargesFor(Performers);
    
  finally

    FreeAndNil(PerformerIds);
    
  end;

end;

function TDocumentObjectsDTODomainMapper.MapDocumentRelationsFrom(
  DocumentRelationsInfoDTO: TDocumentRelationsInfoDTO
): TDocumentRelations;
var DocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := CreateDocumentRelationsInstance;

  try

    for DocumentRelationInfoDTO in DocumentRelationsInfoDTO do begin

      with DocumentRelationInfoDTO do begin

        Result.TargetDocumentId := TargetDocumentId;
        Result.AddRelation(
          RelatedDocumentId, RelatedDocumentKindId
        );
        
      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

procedure TDocumentObjectsDTODomainMapper.
  MapAndAssignApprovingsToDocument(
    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
    Document: IDocument;
    RequestingEmployee: TEmployee
  );
var DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    Approver: TEmployee;
    FreeApprover: IDomainObject;
begin

  for DocumentApprovingInfoDTO in DocumentApprovingsInfoDTO do begin

    with DocumentApprovingInfoDTO do begin

      Approver := FEmployeeRepository.FindEmployeeById(ApproverInfoDTO.Id);

      FreeApprover := Approver;

      Document.AddApprover(RequestingEmployee, Approver);

    end;
    
  end;

end;

procedure TDocumentObjectsDTODomainMapper.ChangeDocumentApprovingsFrom(
  DocumentApprovingsChangesInfoDTO: TDocumentApprovingsInfoDTO;
  Document: IDocument;
  ChangingEmployee: TEmployee
);
var TargetDocument: TDocument;
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    Approver: TEmployee;
    FreeApprover: IDomainObject;
    DocumentApproving: TDocumentApproving;
    RemoveableApprovers: TEmployees; FreeEmployees: IDomainObjectList;
    RemoveableApprover: TEmployee;
begin

  RemoveableApprovers := TEmployees.Create;

  FreeEmployees := RemoveableApprovers;
  
  for DocumentApproving in Document.Approvings do begin

    if not Assigned(
              DocumentApprovingsChangesInfoDTO.FindByApprovingId(
                DOcumentApproving.Identity
              )
           )
    then begin

      RemoveableApprovers.AddDomainObject(DocumentApproving.Approver);
      
    end;

  end;

  for RemoveableApprover in RemoveableApprovers do begin

    Document.RemoveApprover(ChangingEmployee, RemoveableApprover);
    
  end;

  for DocumentApprovingInfoDTO in DocumentApprovingsChangesInfoDTO do begin

    with DocumentApprovingInfoDTO do begin

      Approver := FEmployeeRepository.FindEmployeeById(ApproverInfoDTO.Id);

      FreeApprover := Approver;

      if VarIsNull(DocumentApprovingInfoDTO.Id) or
         (DocumentApprovingInfoDTO.Id < 0)
      then begin

        Document.AddApprover(ChangingEmployee, Approver)

      end
      
      else begin

        DocumentApproving :=
          Document.FindApprovingByFormalApprover(Approver);

        if not Assigned(DocumentApproving) then Continue;
        
        if DocumentApproving.Note <> DocumentApprovingInfoDTO.Note
        then begin

          Document.ChangeNoteForApprover(
            ChangingEmployee,
            Approver,
            DocumentApprovingInfoDTO.Note
          );

        end;
        
      end;

    end;
    
  end;

end;

procedure TDocumentObjectsDTODomainMapper.
  MapAndAssignChargesToDocument(
    DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
    Document: IDocument
  );
var
    AddedCharges: IDocumentCharges;
begin

  if IsNotAssignedOrEmpty(DocumentChargesInfoDTO) then Exit;

  AddedCharges :=
    FChargesInfoDTODomainMapper
      .MapDocumentChargesFrom(DocumentChargesInfoDTO, Document);

  Document.AddCharges(AddedCharges);
  
end;

procedure TDocumentObjectsDTODomainMapper.MapAndAssignSigningsToDocument(
  DocumentSigningsInfoDTO: TDocumentSigningsInfoDTO;
  Document: IDocument
);
var DocumentSigningInfoDTO: TDocumentSigningInfoDTO;

    Signer: TEmployee;
    FreeSigner: IDomainObject;

    ActuallySignedEmployee: TEmployee;
    FreeActuallySignedEmployee: IDomainObject;

    DocumentSigning: TDocumentSigning;
begin

  Signer := nil;

  for DocumentSigningInfoDTO in DocumentSigningsInfoDTO do begin

    with DocumentSigningInfoDTO do begin

      Signer := FEmployeeRepository.FindEmployeeById(SignerInfoDTO.Id);

      FreeSigner := Signer;

      Document.AddSigner(Signer);
        
    end;

  end;

end;

procedure TDocumentObjectsDTODomainMapper.ChangeDocumentSigningsFrom(
  Document: IDocument;
  SigningsInfoDTO: TDocumentSigningsInfoDTO
);
var DocumentSigningInfoDTO: TDocumentSigningInfoDTO;
    Signings: TDocumentSignings;
    Signing: TDocumentSigning;
    Signer: TEmployee; FreeSigner: IDomainObject;
begin

  {
    ¬ 1-ом цикле
    подписанты добавл€ютс€ в том случае,
    если они ещЄ не назначены.
    ¬о 2-ом цикле удал€ютс€ подписанты,
    которые не были обнаружено в DTO.

    Ќа данный момент имеет значение пор€док
    следовани€ циклов. ≈сли документ
    редактирует назначенный подписант, который
    удал€ет себ€ из списка подписантов и
    добавл€ет другого, то правило проверки
    возможности редактировани€ списка подписантов
    сгенерирует исключение, поскольку сотрудник теперь
    не €вл€етс€ ни автором, ни подписантом (удалил себ€ из списка).

    ¬ принципе лучше создать предметную службу дл€
    проверки €вл€етс€ ли сотрудник руководителем
    дл€ автора документа (тогда разрешить ему редактировать
    список подписантов, да и сам документ),
    чтобы исключить зависимость
    пор€дка следовани€ циклов и вообще упростить
    тело этого метода (удалить всех подписантов
    и добавить тех, которые есть в DTO). ќп€ть-таки
    возникает вопрос производительности, ведь
    реализаци€ предметной службы должна будет
    делать запрос к Ѕƒ, и он будет рекурсивным
    вследствии наличи€ иерархии сотрудников. ѕроста€
    проверка Employee.IsLeaderFor(OtherEmployee) дл€
    определени€, €вл€етс€ ли сотрудник Employee
    руководителем дл€ OtherEmployee будет успешной
    только в том случае, если Employee непосредственный
    руководитель. ≈сли между Employee и OtherEmployee
    существует более одного уровн€ иерархии,
    то проверка будет неудачной.
  }

  Signings := Document.Signings;

  for DocumentSigningInfoDTO in SigningsInfoDTO do begin

    if not Assigned(
          Signings.FindDocumentSigningBySignerId(
            DocumentSigningInfoDTO.SignerInfoDTO.Id
          )
       )
    then
    begin

      Signer := FEmployeeRepository.FindEmployeeById(
        DocumentSigningInfoDTO.SignerInfoDTO.Id
      );

      FreeSigner := Signer;

      Document.AddSigner(Signer);
      
    end;
    
  end;

  for Signing in Signings do begin

    if not Assigned(
              SigningsInfoDTO.FindSigningInfoDTOBySignerId(
                Signing.Signer.Identity
              )
      )
    then begin

      Document.RemoveSigner(Signing.Signer);
      
    end;
    
  end;

end;

function TDocumentObjectsDTODomainMapper.
  MapChangedDocumentObjectsBy(
    ChangedDocumentInfoDTO: TChangedDocumentInfoDTO;
    SourceDocument: IDocument;
    ChangingEmployee: TEmployee
  ): TDocumentObjects;
begin

  Result := CreateDocumentObjectsInstance;

  try

    MapChangedDocumentFrom(
      SourceDocument,
      ChangingEmployee,
      ChangedDocumentInfoDTO.ChangedDocumentDTO
    );

    Result.DocumentResponsible :=
      FDocumentResponsibleInfoDTOMapper.MapDocumentResponsibleInfoDTO(
        ChangedDocumentInfoDTO.ChangedDocumentDTO.ResponsibleInfoDTO
      );
      
    Result.DocumentRelations :=
      MapDocumentRelationsFrom(
        ChangedDocumentInfoDTO.ChangedDocumentRelationsInfoDTO
      );

    Result.DocumentFiles :=
      MapDocumentFilesFrom(
        ChangedDocumentInfoDTO.ChangedDocumentFilesInfoDTO
      );

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;
  
end;

function TDocumentObjectsDTODomainMapper.MapDocumentFilesFrom(
  DocumentFilesInfoDTO: TDocumentFilesInfoDTO
): TDocumentFiles;
var DocumentFileInfoDTO: TDocumentFileInfoDTO;
    DocumentFile: TDocumentFile;
    FreeDocumentFile: IDomainObject;
begin

  DocumentFile := nil;
  Result := CreateDocumentFilesInstance;

  try

    for DocumentFileInfoDTO in DocumentFilesInfoDTO do begin

      with DocumentFileInfoDTO do begin

        DocumentFile := TDocumentFile.Create;

        FreeDocumentFile := DocumentFile;
        
        DocumentFile.Identity := Id;
        DocumentFile.DocumentId := DocumentId;
        DocumentFile.FileName := FileName;
        DocumentFile.FilePath := FilePath;

        Result.AddDomainObject(DocumentFile);

      end;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentObjectsDTODomainMapper.MapNewDocumentObjectsBy(
  NewDocumentInfoDTO: TNewDocumentInfoDTO;
  CreatingEmployee: TEmployee
): TDocumentObjects;
var
    Document: IDocument;
begin

  Result := CreateDocumentObjectsInstance;

  try

    Document :=
      MapNewDocumentFrom(
        NewDocumentInfoDTO.DocumentDTO,
        CreatingEmployee
      );

    Result.Document := Document.Self as TDocument;

    Result.DocumentResponsible :=
      FDocumentResponsibleInfoDTOMapper.MapDocumentResponsibleInfoDTO(
        NewDocumentInfoDTO.DocumentDTO.ResponsibleInfoDTO
      );

    Result.DocumentRelations :=
      MapDocumentRelationsFrom(
        NewDocumentInfoDTO.DocumentRelationsInfoDTO
      );

    Result.DocumentFiles :=
      MapDocumentFilesFrom(NewDocumentInfoDTO.DocumentFilesInfoDTO);

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

{ TDocumentObjects }

procedure TDocumentObjects.SetDocument(Document: TDocument);
begin

  FDocument := Document;
  FFreeDocument := Document;
  
end;

procedure TDocumentObjects.SetDocumentFiles(const Value: TDocumentFiles);
begin

  FDocumentFiles := Value;
  FFreeDocumentFiles := Value;

end;

procedure TDocumentObjects.SetDocumentRelations(
  const Value: TDocumentRelations);
begin

  FDocumentRelations := Value;
  FFreeDocumentRelations := Value;
  
end;

procedure TDocumentObjects.SetDocumentResponsible(const Value: TEmployee);
begin

  FDocumentResponsible := Value;
  FFreeDocumentResponsible := Value;
  
end;

end.
