unit StandardRespondingDocumentCreatingService;

interface

uses

  RespondingDocumentCreatingService,
  Document,
  DocumentRelationsUnit,
  DocumentFullNameCompilationService,
  EmployeeSubordinationService,
  DocumentUsageEmployeeAccessRightsInfo,
  DocumentUsageEmployeeAccessRightsService,
  DocumentChargeCreatingService,
  DocumentCreatingService,
  DocumentNumeratorRegistry,
  DepartmentFinder,
  DocumentChargeInterface,
  FormalDocumentSignerFinder,
  IDocumentUnit,
  DocumentCharges,
  Department,
  Employee,
  SysUtils,
  Classes;

type

  TStandardRespondingDocumentCreatingService =
    class (TInterfacedObject, IRespondingDocumentCreatingService)

      protected

        function CreateRespondingDocumentResultFor(
          const SourceDocument: IDocument;
          const RequestingEmployee: TEmployee
        ): TRespondingDocumentCreatingResult; virtual;

        function CreateRespondingDocumentInstanceFor(
          const SourceDocument: IDocument;
          const RequestingEmployee: TEmployee
        ): IDocument; virtual;

        procedure FillRespondingDocument(
          RespondingDocument: IDocument;
          const SourceDocument: IDocument;
          const RequestingEmployee: TEmployee
        ); virtual;

        function CreateRespondingDocumentRelationsFrom(
          const RespondingDocument: IDocument;
          const SourceDocument: IDocument
        ): TDocumentRelations; virtual;

      protected

        FIncomingDocumentUsageEmployeeAccessRightsService:
          IDocumentUsageEmployeeAccessRightsService;

        FRespondingDocumentUsageEmployeeAccessRightsService:
          IDocumentUsageEmployeeAccessRightsService;
          
        procedure RaiseExceptionIfDocumentIsNotIncoming(const SourceDocument: IDocument);

        procedure RaiseExceptionIfEmployeeHasNotDocumentUsageAccessRights(
          const RequestingEmployee: TEmployee;
          const SourceDocument: IDocument
        );

      protected

        FDocumentFullNameCompilationService: IDocumentFullNameCompilationService;

        FDocumentCreatingService: IDocumentCreatingService;
        
        function GetRespondingDocumentNameFrom(const SourceDocument: IDocument): String; virtual;
        function GetRespondingDocumentContentFrom(const SourceDocument: IDocument): String; virtual;

      protected

        FEmployeeSubordinationService: IEmployeeSubordinationService;
        
        function FindSignerFor(
          const RespondingDocument: IDocument;
          const SourceDocument: IDocument;
          const RequestingEmployee: TEmployee
        ): TEmployee; virtual;

      protected

        FFormalDocumentSignerFinder: IFormalDocumentSignerFinder;
        
        procedure AddRespondingDocumentCharge(
          RespondingDocument: IDocument;
          SourceDocument: IDocument
        ); virtual;

      public

        constructor Create(
          DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
          DocumentCreatingService: IDocumentCreatingService;
          IncomingDocumentUsageEmployeeAccessRightsService: IIncomingDocumentUsageEmployeeAccessRightsService;
          RespondingDocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
          FormalDocumentSignerFinder: IFormalDocumentSignerFinder;
          EmployeeSubordinationService: IEmployeeSubordinationService
        );
        
        function CreateRespondingDocumentFor(
          const SourceDocument: IDocument;
          const RequestingEmployee: TEmployee
        ): TRespondingDocumentCreatingResult; virtual;

        function GetSelf: TObject;

    end;

implementation

uses

  AuxiliaryStringFunctions,
  DocumentKind,
  DocumentNumerator,
  StandardDocumentNumerator,
  DocumentChargeServiceRegistry,
  DocumentRuleRegistry,
  IDomainObjectBaseUnit,
  IncomingDocument;

{ TStandardRespondingDocumentCreatingService }

procedure TStandardRespondingDocumentCreatingService.AddRespondingDocumentCharge(
  RespondingDocument, SourceDocument: IDocument
);
var
    SourceDocumentSigner,
    RespondingDocumentSigner: TEmployee;

    SourceDocumentCharge, RespondingDocumentCharge: IDocumentCharge;

    Free: IDomainObjectBase;

    DocumentChargeCreatingService: IDocumentChargeCreatingService;
begin

  SourceDocumentSigner :=
    FFormalDocumentSignerFinder.GetFormalDocumentSigner(SourceDocument);

  if not Assigned(SourceDocumentSigner) then Exit;

  Free := SourceDocumentSigner;

  RespondingDocumentSigner :=
    RespondingDocument.Signings.First.Signer;

  SourceDocumentCharge :=
    SourceDocument
      .Charges
        .FindDocumentChargeByPerformerOrActuallyPerformedEmployee(
          RespondingDocumentSigner
        );

  if not Assigned(SourceDocumentCharge) then
    SourceDocumentCharge := SourceDocument.Charges.First;

  if not Assigned(SourceDocumentCharge) then begin

    raise TRespondingDocumentCreatingServiceException.Create(
      'Ќевозможно создать поручение на ответный документ, ' +
      'поскольку не найдено соответстующее поручение ' +
      'в исходном документе'
    );
    
  end;

  DocumentChargeCreatingService :=
    TDocumentChargeServiceRegistry.Instance.GetDocumentChargeCreatingService(
      TDocumentCharge(SourceDocumentCharge.Self).ClassType
    );

  RespondingDocumentCharge :=
    DocumentChargeCreatingService.CreateDocumentCharge(
      SourceDocumentCharge.KindId,
      RespondingDocument,
      SourceDocumentSigner
    );

  RespondingDocument.AddCharge(RespondingDocumentCharge);
  
end;

constructor TStandardRespondingDocumentCreatingService.Create(
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  DocumentCreatingService: IDocumentCreatingService;
  IncomingDocumentUsageEmployeeAccessRightsService: IIncomingDocumentUsageEmployeeAccessRightsService;
  RespondingDocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
  FormalDocumentSignerFinder: IFormalDocumentSignerFinder;
  EmployeeSubordinationService: IEmployeeSubordinationService
);
begin

  inherited Create;

  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  FDocumentCreatingService := DocumentCreatingService;
  FIncomingDocumentUsageEmployeeAccessRightsService := IncomingDocumentUsageEmployeeAccessRightsService;
  FRespondingDocumentUsageEmployeeAccessRightsService := RespondingDocumentUsageEmployeeAccessRightsService;
  FFormalDocumentSignerFinder := FormalDocumentSignerFinder;
  FEmployeeSubordinationService := EmployeeSubordinationService;

end;

function TStandardRespondingDocumentCreatingService.CreateRespondingDocumentFor(
  const SourceDocument: IDocument;
  const RequestingEmployee: TEmployee
): TRespondingDocumentCreatingResult;
begin

  RaiseExceptionIfDocumentIsNotIncoming(SourceDocument);

  RaiseExceptionIfEmployeeHasNotDocumentUsageAccessRights(
    RequestingEmployee, SourceDocument
  );

  Result := CreateRespondingDocumentResultFor(SourceDocument, RequestingEmployee);

end;

procedure TStandardRespondingDocumentCreatingService.RaiseExceptionIfDocumentIsNotIncoming(
  const SourceDocument: IDocument);
begin

  if not (SourceDocument.Self is TIncomingDocument) then begin

    TRespondingDocumentCreatingServiceException.Create(
      'ƒокумент, дл€ которого затребовано создание ' +
      'ответного документа, не €вл€етс€ вход€щим'
    );
    
  end;

end;

procedure TStandardRespondingDocumentCreatingService.
  RaiseExceptionIfEmployeeHasNotDocumentUsageAccessRights(
    const RequestingEmployee: TEmployee;
    const SourceDocument: IDocument
  );
begin

  FIncomingDocumentUsageEmployeeAccessRightsService.
    EnsureThatEmployeeHasDocumentUsageAccessRights(
      SourceDocument, RequestingEmployee
    ).Free;

end;

function TStandardRespondingDocumentCreatingService.
  CreateRespondingDocumentResultFor(
    const SourceDocument: IDocument;
    const RequestingEmployee: TEmployee
  ): TRespondingDocumentCreatingResult;
var
    RespondingDocument: IDocument;

    RespondingDocumentRelations: TDocumentRelations;
    FreeRespondingDocumentRelations: IDomainObjectBase;

    RespondingDocumentAccessRights: TDocumentUsageEmployeeAccessRightsInfo;
    FreeRespondingDocumentAccessRights: IDomainObjectBase;
begin

  RespondingDocument :=
    CreateRespondingDocumentInstanceFor(SourceDocument, RequestingEmployee);

  with TDocument(RespondingDocument.Self) do begin

    InvariantsComplianceRequested := False;

    FillRespondingDocument(RespondingDocument, SourceDocument, RequestingEmployee);

    InvariantsComplianceRequested := True;

  end;

  RespondingDocumentRelations :=
    CreateRespondingDocumentRelationsFrom(
      RespondingDocument, SourceDocument
    );

  FreeRespondingDocumentRelations := RespondingDocumentRelations;

  RespondingDocumentAccessRights :=
    FRespondingDocumentUsageEmployeeAccessRightsService
      .EnsureThatEmployeeHasDocumentUsageAccessRights(
        RespondingDocument, RequestingEmployee
      );

  FreeRespondingDocumentAccessRights := RespondingDocumentAccessRights;
  
  Result :=
    TRespondingDocumentCreatingResult.Create(
      RespondingDocument,
      RespondingDocumentRelations,
      RespondingDocumentAccessRights
    );

end;

function TStandardRespondingDocumentCreatingService.
  CreateRespondingDocumentInstanceFor(
    const SourceDocument: IDocument;
    const RequestingEmployee: TEmployee
  ): IDocument;
begin

  Result :=
    FDocumentCreatingService.CreateDocumentInstanceForEmployee(RequestingEmployee);

end;

procedure TStandardRespondingDocumentCreatingService.FillRespondingDocument(
  RespondingDocument: IDocument;
  const SourceDocument: IDocument;
  const RequestingEmployee: TEmployee
);
var
    RespondingDocumentSigner: TEmployee;
    Free: IDomainObjectBase;
begin

  RespondingDocument.CreationDate := Now;
  RespondingDocument.Content := GetRespondingDocumentContentFrom(SourceDocument);
  RespondingDocument.Name := GetRespondingDocumentNameFrom(SourceDocument);
  RespondingDocument.ResponsibleId := RequestingEmployee.LegacyIdentity;
  
  RespondingDocumentSigner :=
    FindSignerFor(RespondingDocument, SourceDocument, RequestingEmployee);

  Free := RespondingDocumentSigner;

  if Assigned(RespondingDocumentSigner) then
    RespondingDocument.AddSigner(RespondingDocumentSigner);

  AddRespondingDocumentCharge(RespondingDocument, SourceDocument);
  
end;

function TStandardRespondingDocumentCreatingService.GetRespondingDocumentNameFrom(
  const SourceDocument: IDocument
): String;
begin

  Result :=
    Format(
      'ќтвет на %s',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          SourceDocument
        )
      ]
    );
    
end;

function TStandardRespondingDocumentCreatingService.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TStandardRespondingDocumentCreatingService.GetRespondingDocumentContentFrom(
  const SourceDocument: IDocument): String;
begin

  Result :=
    '¬ ответ на ' +
    FDocumentFullNameCompilationService
      .CompileNameWithoutManualNameForDocument(SourceDocument);
  
end;

function TStandardRespondingDocumentCreatingService.FindSignerFor(
  const RespondingDocument: IDocument;
  const SourceDocument: IDocument;
  const RequestingEmployee: TEmployee
): TEmployee;
begin

  Result :=
    FEmployeeSubordinationService
      .FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(
        RequestingEmployee
      );

end;

function TStandardRespondingDocumentCreatingService.
  CreateRespondingDocumentRelationsFrom(
    const RespondingDocument, SourceDocument: IDocument
  ): TDocumentRelations;
begin

  Result := TDocumentRelations.Create(RespondingDocument.Identity);

  try

    Result.AddRelation(SourceDocument.Identity, SourceDocument.KindIdentity);
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
