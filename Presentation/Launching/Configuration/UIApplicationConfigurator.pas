unit UIApplicationConfigurator;

interface

uses

  ConfigurationData,
  ApplicationConfigurator,
  IObjectPropertiesStorageRegistryUnit,
  DocumentApprovingSheetViewModelMapperFactories,
  UIControlsTrackingStylist,
  DocumentKinds,
  UIDocumentKinds,
  UIDocumentKindMapper,
  SysUtils,
  Classes;

type

  TUIApplicationConfigurator = class

    private

      FApplicationConfigurator: TApplicationConfigurator;
      FUIControlsTrackingStylist: TUIControlsTrackingStylist;
      FUIDocumentKindMapper: IUIDocumentKindMapper;

    private

      procedure ConfigureApplicationPropertiesIniFileRegistry(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String
      );

      procedure CustomizeDocumentPrimaryScreensPropertiesIniFile(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeMainApplicationFramePropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeSecondaryDocumentScreensPropertiesIniFile(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentReportFormsPropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentKindsFramePropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentCardListFramePropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizePropertiesIniFilesForAllDocumentFlowItems(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure ConfigureDocumentKindPropertiesIniFiles(
        const DocumentKind: TUIDocumentKindClass;
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentsReferenceFormsPropertiesIniFiles(
        const DocumentKind: TUIDocumentKindClass;
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentChargesFramePropertiesIniFiles(
        const DocumentKind: TUIDocumentKindClass;
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentChargePerformersReferenceFormPropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentCardFramePropertiesIniFiles(
        const DocumentKind: TUIDocumentKindClass;
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CreateApplicationMainForm(
        ConfigurationData: TConfigurationData
      );

      procedure OnMainFrameLayoutReadyHandler(ASender: TObject);

    private

      procedure ConfigureGlobalStylization;
      procedure ConfigureSDTableFormStyle;
      procedure ConfigureAdministrationFormStyle;

    private

      procedure ConfigureRegistries;
      procedure ConfigureDocumentReportPresenterRegistry;
      procedure ConfigureApplicationPropertiesStorageRegistry;

    private

      procedure ConfigureFactories;
      procedure ConfigureDocumentDataSetHoldersFactories;
      procedure ConfigureDocumentCardFormViewModelFactories;
      procedure ConfigureDocumentApprovingSheetViewModelMapperFactories;
      procedure ConfigureDocumentCardFrameFactories;
      
    public

      destructor Destroy; override;
      constructor Create;

      procedure Configure(ConfigurationData: TConfigurationData);

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  AuxSystemFunctionsUnit,
  Forms,
  unApplicationMainFrame,
  ZConnection,
  Session,
  ZeosPostgresTransactionUnit,
  DatabaseTransactionUnit,
  ApplicationPropertiesStorageRegistry,
  ObjectPropertiesStorageRegistry,
  ApplicationMainFramePropertiesIniFile,
  TableViewFilterFormUnit,
  unDocumentChargeSheetPerformersReferenceForm,
  IDocumentReportPresenterRegistryUnit,
  DocumentReportPresenterRegistry,
  StandardDocumentReportPresenterRegistry,
  NotPerformedDocumentsReportFastReportPresenter,
  NotPerformedIncomingDocumentsReportFastReportPresenter,
  DB,
  RegExpr,
  AuxZeosFunctions,
  ZDataset,
  unDocumentChargesFrame,
  unDocumentCardFrame,
  unDocumentKindsFrame,
  DocumentCardFramePropertiesIniFile,
  DocumentChargesFramePropertiesIniFile,
  AccountingServiceRegistry,
  DocumentViewingAccountingService,
  DocumentPrintFormPresenter,
  ServiceNotePrintFormFastReportPresenter,
  ApplicationServiceRegistries,
  WorkingEmployeeUnit,
  DocumentRecordsPanelSettingsFormPropertiesIniFile,
  DocumentRecordsPanelSettingsFormUnit,
  UIDocumentKindResolver,
  unDocumentChargeSheetsFrame,
  DocumentsReferenceViewModelFactory,
  NumericDocumentKindResolver,
  DocumentKindsPanelController,
  ClientDataSetBuilder,
  unDocumentCardListFrame,
  DocumentCardListFramePropertiesIniFile,
  DocumentKindsFormViewModelMapper,
  DocumentKindsFramePropertiesIniFile,
  StandardUIDocumentKindResolver,
  StandardDocumentsReferenceFormPresenter,
  Controls,
  unApplicationMainForm,
  DBDataTableFormStyle,
  CommonControlStyles,
  SDBaseTableFormUnit,
  SectionStackedFormStyle,
  unDocumentFlowAdministrationForm,
  DocumentsReferenceFormFactory,
  UIControlStyle,
  AppDataLocalSettingsResetService,
  StandardApplicationSettingsResetService,
  unSelectionDepartmentsReferenceForm,
  NotPerformedDocumentsReportPresenter,
  EmployeeDocumentsReferenceFormProcessorFactory,
  DocumentsReferenceFormPropertiesIniFile,
  DocumentsReferenceFilterFormStatePropertiesIniFile,
  unOutcomingServiceNotesReferenceForm,
  unIncomingServiceNotesReferenceForm,
  unApproveableServiceNotesReferenceForm,
  ClientDataSetBuilderFactory,
  MemTableEhBuilder,
  DocumentApprovingSheetViewModelMapperFactory,
  DocumentCardFormViewModelMapperFactories,
  DocumentApprovingSheetFastReportPresenter,
  DocumentDataSetHoldersFactory,
  DocumentDataSetHoldersFactories,
  DocumentCardFrameFactories,
  StandardUIDocumentKindMapper,
  unVersionInfosForm,
  MemTableEhBuilderFactory,
  ApplicationVersionInfoService,
  VersionInfoDTOs,
  GlobalDocumentKindsReadService,
  unServiceNoteChargesFrame,
  unServiceNoteChargeSheetsFrame,
  unPersonnelOrderChargesFrame,  
  unPersonnelOrderChargeSheetsFrame,
  unServiceNoteCardFrame,
  NativeDocumentKindsReadService,
  unPersonnelOrderCardFrame,
  DocumentKindDto;

{ TUIApplicationConfigurator }

procedure TUIApplicationConfigurator.Configure(
  ConfigurationData: TConfigurationData);
begin

  FApplicationConfigurator.Configure(ConfigurationData);

  ConfigureFactories;
  ConfigureRegistries;
  CreateApplicationMainForm(ConfigurationData);
  ConfigureGlobalStylization;
  
end;

procedure TUIApplicationConfigurator.
  ConfigureApplicationPropertiesStorageRegistry;
begin

  ConfigureApplicationPropertiesIniFileRegistry(
    GetAppLocalDataFolderPath('umz_doc', CreateFolderIfNotExists),
    GetAppLocalDataFolderPath('umz_doc_default', CreateFolderIfNotExists)
  );

end;

procedure TUIApplicationConfigurator.ConfigureApplicationPropertiesIniFileRegistry(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String
);
var
    ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry;
begin

  ApplicationPropertiesIniFilesRegistry :=
    TApplicationPropertiesStorageRegistry.Current;

  CustomizeDocumentPrimaryScreensPropertiesIniFile(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeSecondaryDocumentScreensPropertiesIniFile(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizePropertiesIniFilesForAllDocumentFlowItems(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentPrimaryScreensPropertiesIniFile(
  const AppPropertiesDirPath, DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  CustomizeMainApplicationFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

  CustomizeDocumentKindsFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

  CustomizeDocumentCardListFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

end;

procedure TUIApplicationConfigurator.CustomizeSecondaryDocumentScreensPropertiesIniFile(
  const AppPropertiesDirPath, DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry);
begin

  CustomizeDocumentReportFormsPropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

  CustomizeDocumentChargePerformersReferenceFormPropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentReportFormsPropertiesIniFiles(
  const AppPropertiesDirPath, DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  PropertiesIniFilesRegistry
    .RegisterObjectPropertiesStorageForObjectClass(
      TDocumentRecordsPanelSettingsForm,
      TDocumentRecordsPanelSettingsFormPropertiesIniFile.Create(
        AppPropertiesDirPath + PathDelim + 'document_records_panel_settings_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'document_records_panel_settings_form.ini'
      )
    );

end;

procedure TUIApplicationConfigurator.CustomizePropertiesIniFilesForAllDocumentFlowItems(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
var
    DocumentKindsReadService: INativeDocumentKindsReadService;
    DocumentKindDtos: TDocumentKindDtos;
    DocumentKindDto: TDocumentKindDto;
    UIDocumentKindMapper: IUIDocumentKindMapper;
    UIDocumentKind: TUIDocumentKindClass;
begin

  DocumentKindsReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetNativeDocumentKindsReadService;

  DocumentKindDtos :=
    DocumentKindsReadService
      .GetServicedDocumentKindDtos;

  UIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;
  
  try

    for DocumentKindDto in DocumentKindDtos do begin
    
      UIDocumentKind := 
        UIDocumentKindMapper.MapUIDocumentKindFrom(DocumentKindDto.ServiceType);
      
      if 
        UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) 
        or UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind)
      then Continue;

      ConfigureDocumentKindPropertiesIniFiles(
        UIDocumentKind,
        AppPropertiesDirPath,
        DefaultAppPropertiesDirPath,
        PropertiesIniFilesRegistry
      );
      
    end;

  finally

    FreeAndNil(DocumentKindDtos);
    
  end;
  
end;

procedure TUIApplicationConfigurator.ConfigureDocumentKindPropertiesIniFiles(
  const DocumentKind: TUIDocumentKindClass;
  const AppPropertiesDirPath,
  DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  CustomizeDocumentsReferenceFormsPropertiesIniFiles(
    DocumentKind,
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

  CustomizeDocumentChargesFramePropertiesIniFiles(
    DocumentKind,
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

  CustomizeDocumentCardFramePropertiesIniFiles(
    DocumentKind,
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    PropertiesIniFilesRegistry
  );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentsReferenceFormsPropertiesIniFiles(
  const DocumentKind: TUIDocumentKindClass;
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
var
    DocumentsReferenceFormKind,
    IncomingDocumentsReferenceFormKind,
    ApproveableDocumentsReferenceFormKind: TClass;

    DocumentsReferenceFormIniFile, DocumentsReferenceFilterFormIniFile,
    IncomingDocumentsReferenceFormIniFile, IncomingDocumentsReferenceFilterFormIniFile,
    ApproveableDocumentsReferenceFormIniFile, ApproveableDocumentsReferenceFilterFormIniFile: String;

    DefaultDocumentsReferenceFormIniFile, DefaultDocumentsReferenceFilterFormIniFile,
    DefaultIncomingDocumentsReferenceFormIniFile, DefaultIncomingDocumentsReferenceFilterFormIniFile,
    DefaultApproveableDocumentsReferenceFormIniFile, DefaultApproveableDocumentsReferenceFilterFormIniFile: String;
begin

  DocumentsReferenceFormKind := nil;
  IncomingDocumentsReferenceFormKind := nil;
  ApproveableDocumentsReferenceFormKind := nil;

  if DocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) then begin

    DocumentsReferenceFormKind := TOutcomingServiceNotesReferenceForm;
    IncomingDocumentsReferenceFormKind := TIncomingServiceNotesReferenceForm;
    ApproveableDocumentsReferenceFormKind := TApproveableServiceNotesReferenceForm;

    DocumentsReferenceFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_documents_form.ini';

    DocumentsReferenceFilterFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_documents_form_filter_state.ini';


    IncomingDocumentsReferenceFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form.ini';

    IncomingDocumentsReferenceFilterFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form_filter_state.ini';


    ApproveableDocumentsReferenceFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_form.ini';

    ApproveableDocumentsReferenceFilterFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form_filter_state.ini';


    DefaultDocumentsReferenceFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_documents_form.ini';

    DefaultDocumentsReferenceFilterFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_documents_form_filter_state.ini';


    DefaultIncomingDocumentsReferenceFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form.ini';

    DefaultIncomingDocumentsReferenceFilterFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form_filter_state.ini';

    DefaultApproveableDocumentsReferenceFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_form.ini';

    DefaultApproveableDocumentsReferenceFilterFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_filter_form_state.ini';

  end

  else if DocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    DocumentsReferenceFormKind := TUIPersonnelOrderKind;

    DocumentsReferenceFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_personnel_orders_form.ini';

    DocumentsReferenceFilterFormIniFile :=
      AppPropertiesDirPath + PathDelim + 'employee_personnel_orders_filter_form.ini';

    DefaultDocumentsReferenceFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_personnel_orders_form.ini';

    DefaultDocumentsReferenceFilterFormIniFile :=
      DefaultAppPropertiesDirPath + PathDelim + 'employee_personnel_orders_filter_form.ini';

  end

  else Raise Exception.Create('DocumentKind is not accounted for document type ' + DocumentKind.ClassName);

  ApplicationPropertiesIniFilesRegistry
    .RegisterObjectPropertiesStorageForObjectClass(

      DocumentsReferenceFormKind,

      TDocumentsReferenceFormPropertiesIniFile.Create(

        TDocumentsReferenceFilterFormStatePropertiesIniFile.
          Create(
            DocumentsReferenceFilterFormIniFile,
            DefaultDocumentsReferenceFilterFormIniFile
          ),

        DocumentsReferenceFormIniFile,
        DefaultDocumentsReferenceFormIniFile
      ),

      RegisterWithoutInheritanceCheckingOption
    );

  if Assigned(IncomingDocumentsReferenceFormKind) then begin

    ApplicationPropertiesIniFilesRegistry.
      RegisterObjectPropertiesStorageForObjectClass(

        IncomingDocumentsReferenceFormKind,

        TDocumentsReferenceFormPropertiesIniFile.Create(

          TDocumentsReferenceFilterFormStatePropertiesIniFile.Create(
            IncomingDocumentsReferenceFilterFormIniFile,
            DefaultIncomingDocumentsReferenceFilterFormIniFile
          ),

          IncomingDocumentsReferenceFormIniFile,
          DefaultIncomingDocumentsReferenceFormIniFile
        )
      );

  end;

  if Assigned(ApproveableDocumentsReferenceFormKind) then begin

    ApplicationPropertiesIniFilesRegistry
      .RegisterObjectPropertiesStorageForObjectClass(

        ApproveableDocumentsReferenceFormKind,

        TDocumentsReferenceFormPropertiesIniFile.Create(

          TDocumentsReferenceFilterFormStatePropertiesIniFile.Create(
            ApproveableDocumentsReferenceFilterFormIniFile,
            DefaultApproveableDocumentsReferenceFilterFormIniFile
          ),

          ApproveableDocumentsReferenceFormIniFile,
          DefaultApproveableDocumentsReferenceFormIniFile
        )
      );

  end;

end;

procedure TUIApplicationConfigurator.
  CustomizeDocumentCardFramePropertiesIniFiles(
    const DocumentKind: TUIDocumentKindClass;
    const AppPropertiesDirPath: String;
    const DefaultAppPropertiesDirPath: String;
    PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
  );
var
    DocumentCardFrameKind: TClass;
    CardFramePropertiesIniFilePath, DefaultCardFramePropertiesIniFilePath: String;
begin

  if DocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind)
  then begin

    DocumentCardFrameKind := TServiceNoteCardFrame;

    CardFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'DocumentCardFrame.ini';

    DefaultCardFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'DocumentCardFrame.ini';

  end

  else if DocumentKind.InheritsFrom(TUIPersonnelOrderKind)
  then begin

    DocumentCardFrameKind := TPersonnelOrderCardFrame;

    CardFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'PersonnelOrderCardFrame.ini';

    DefaultCardFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'PersonnelOrderCardFrame.ini';

  end

  else Raise Exception.Create('DocumentCardFrameKind is not accounted for document type %s' + DocumentKind.ClassName);

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    DocumentCardFrameKind,
    TDocumentCardFramePropertiesIniFile.Create(
      CardFramePropertiesIniFilePath,
      DefaultCardFramePropertiesIniFilePath
    )
  );

end;

procedure TUIApplicationConfigurator.
  CustomizeDocumentChargesFramePropertiesIniFiles(
    const DocumentKind: TUIDocumentKindClass;
    const AppPropertiesDirPath: String;
    const DefaultAppPropertiesDirPath: String;
    PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
  );
var
    DocumentChargesFrameKind, DocumentChargeSheetsFrameKind: TClass;

    ChargeSheetsFramePropertiesIniFilePath, DefaultChargeSheetsFramePropertiesIniFilePath,
    ChargesFramePropertiesIniFilePath, DefaultChargesFramePropertiesIniFilePath: String;
begin

  { refactor: map for ui document kind to charge kind, automatically calc name of inis based on ui doc kind's name }
  
  if DocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) then begin

    DocumentChargesFrameKind := TServiceNoteChargesFrame;
    DocumentChargeSheetsFrameKind := TServiceNoteChargeSheetsFrame;

    ChargesFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'DocumentChargesFrame.ini';

    DefaultChargesFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'DocumentChargesFrame.ini';

    ChargeSheetsFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'IncomingDocumentChargesFrame.ini';

    DefaultChargeSheetsFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'IncomingDocumentChargesFrame.ini';

  end

  else if DocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    DocumentChargesFrameKind := TPersonnelOrderChargesFrame;
    DocumentChargeSheetsFrameKind := TPersonnelOrderChargeSheetsFrame;

    ChargesFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'PersonnelOrderChargesFrame.ini';

    DefaultChargesFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'PersonnelOrderChargesFrame.ini';

    ChargeSheetsFramePropertiesIniFilePath :=
      AppPropertiesDirPath + PathDelim + 'PersonnelOrderChargeSheetsFrame.ini';

    DefaultChargeSheetsFramePropertiesIniFilePath :=
      DefaultAppPropertiesDirPath + PathDelim + 'PersonnelOrderChargeSheetsFrame.ini';

  end

  else Raise Exception.Create('DocumentChargeKind is not accounted for document type %s' + DocumentKind.ClassName);

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    DocumentChargesFrameKind,
    TDocumentChargesFramePropertiesIniFile.Create(
      ChargesFramePropertiesIniFilePath,
      DefaultChargesFramePropertiesIniFilePath
    )
  );

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    DocumentChargeSheetsFrameKind,
    TDocumentChargesFramePropertiesIniFile.Create(
      ChargeSheetsFramePropertiesIniFilePath,
      DefaultChargeSheetsFramePropertiesIniFilePath
    )
  );

end;

procedure TUIApplicationConfigurator.CustomizeMainApplicationFramePropertiesIniFiles(
  const AppPropertiesDirPath, DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry);
begin

  PropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(

      TApplicationMainFrame,

      TApplicationMainFramePropertiesIniFile.Create(
        AppPropertiesDirPath + PathDelim + 'MainForm.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'MainForm.ini'
      )
    );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentCardListFramePropertiesIniFiles(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    TDocumentCardListFrame,
    TDocumentCardListFramePropertiesIniFile.Create(
      AppPropertiesDirPath + PathDelim + 'MainForm.ini',
      DefaultAppPropertiesDirPath + PathDelim + 'MainForm.ini'
    )
  );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentChargePerformersReferenceFormPropertiesIniFiles(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  ApplicationPropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(

      TDocumentChargeSheetPerformersReferenceForm,

      TDocumentsReferenceFormPropertiesIniFile.Create(

        TDocumentsReferenceFilterFormStatePropertiesIniFile.
          Create(
            AppPropertiesDirPath + PathDelim + 'incomming_service_note_receivers_reference_filter_form.ini',
            DefaultAppPropertiesDirPath + PathDelim + 'incomming_service_note_receivers_reference_filter_form.ini'
          ),

        AppPropertiesDirPath + PathDelim + 'incomming_service_note_receivers_reference_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'incomming_service_note_receivers_reference_form.ini'
      )
    );

end;

procedure TUIApplicationConfigurator.CustomizeDocumentKindsFramePropertiesIniFiles(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    TDocumentKindsFrame,
    TDocumentKindsFramePropertiesIniFile.Create(
      AppPropertiesDirPath + PathDelim + 'MainForm.ini',
      DefaultAppPropertiesDirPath + PathDelim + 'MainForm.ini'
    )
  );

end;

procedure TUIApplicationConfigurator.
  ConfigureDocumentApprovingSheetViewModelMapperFactories;
begin

  TDocumentApprovingSheetViewModelMapperFactories
    .SetDocumentApprovingSheetViewModelMapperFactory(
      TUINativeDocumentKind,
      TDocumentApprovingSheetViewModelMapperFactory.Create(
        TClientDataSetBuilderFactory.Create
      )
    );

end;

procedure TUIApplicationConfigurator.ConfigureDocumentCardFormViewModelFactories;
begin

  TDocumentCardFormViewModelMapperFactories.Current :=
    TDocumentCardFormViewModelMapperFactories.Create(
      TDocumentDataSetHoldersFactories.Instance
    );

end;

procedure TUIApplicationConfigurator.ConfigureDocumentCardFrameFactories;
begin


end;

procedure TUIApplicationConfigurator.ConfigureDocumentReportPresenterRegistry;

var
    DocumentReportPresenerRegistry: IDocumentReportPresenterRegistry;
    ServiceNotePrintFormPresenter: IDocumentPrintFormPresenter;

    NotPerformedDocumentsReportPresenter: INotPerformedDocumentsReportPresenter;
    NotPerformedIncomingDocumentsReportPresenter: INotPerformedDocumentsReportPresenter;
begin

  DocumentReportPresenerRegistry :=
    TStandardDocumentReportPresenterRegistry.Create;

  TDocumentReportPresenterRegistry.Current := DocumentReportPresenerRegistry;

  NotPerformedDocumentsReportPresenter :=
    TNotPerformedDocumentsReportFastReportPresenter.Create;

  NotPerformedIncomingDocumentsReportPresenter :=
    TNotPerformedIncomingDocumentsReportFastReportPresenter.Create;

  DocumentReportPresenerRegistry.RegisterNotPerformedDocumentsReportPresenter(
    TUINativeDocumentKind,
    NotPerformedDocumentsReportPresenter
  );
  
  DocumentReportPresenerRegistry.RegisterNotPerformedDocumentsReportPresenter(
    TUIIncomingDocumentKind,
    NotPerformedIncomingDocumentsReportPresenter
  );

  DocumentReportPresenerRegistry.RegisterNotPerformedDocumentsReportPresenter(
    TUIOutcomingDocumentKind,
    NotPerformedIncomingDocumentsReportPresenter
  );
  
  ServiceNotePrintFormPresenter :=
    TServiceNotePrintFormFastReportPresenter.Create;

  DocumentReportPresenerRegistry.RegisterDocumentPrintFormPresenter(
    TUIOutcomingServiceNoteKind, ServiceNotePrintFormPresenter
  );

  DocumentReportPresenerRegistry.RegisterDocumentPrintFormPresenter(
    TUIIncomingServiceNoteKind, ServiceNotePrintFormPresenter
  );

  DocumentReportPresenerRegistry.RegisterDocumentApprovingSheetPresenter(
    TUINativeDocumentKind,
    TDocumentApprovingSheetFastReportPresenter.Create
  );

end;

procedure TUIApplicationConfigurator.ConfigureFactories;
begin

  ConfigureDocumentDataSetHoldersFactories;
  ConfigureDocumentCardFormViewModelFactories;
  ConfigureDocumentApprovingSheetViewModelMapperFactories;
  ConfigureDocumentCardFrameFactories;
 
end;

procedure TUIApplicationConfigurator.ConfigureGlobalStylization;
var
   DBDataTableFormStyle: TDBDataTableFormStyle;
begin

  ConfigureSDTableFormStyle;
  ConfigureAdministrationFormStyle;
  
  FUIControlsTrackingStylist.RunTracking;

end;

procedure TUIApplicationConfigurator.ConfigureRegistries;
begin

  ConfigureDocumentReportPresenterRegistry;
  ConfigureApplicationPropertiesStorageRegistry;

end;

procedure TUIApplicationConfigurator.ConfigureSDTableFormStyle;
var
    SDTableFormStyle: TDBDataTableFormStyle;
begin

  SDTableFormStyle :=
    TDBDataTableFormStyle
      .Create
      .RecordGridSkinName('UserSkin')
      .RecordMovingToolBarVisible(False)
      .FocusedRecordColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormFocusedRecordColor
      )
      .FocusedRecordTextColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormFocusedCellTextColor
      )
      .SelectedRecordColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormSelectedRecordColor
      )
      .SelectedRecordTextColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormSelectedCellTextColor
      );

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TSDBaseTableForm, SDTableFormStyle
  );
      
end;

procedure TUIApplicationConfigurator.ConfigureAdministrationFormStyle;
var
    AdministrationFormStyle: IUIControlStyle;
begin

  AdministrationFormStyle :=
    TSectionStackedFormStyle
      .Create
      .SectionItemColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormFocusedRecordColor
      )
      .SectionItemTextColor(
        TDocumentFlowCommonControlStyles
          .GetDocumentFlowBaseReferenceFormFocusedCellTextColor
      )
      .SectionContentSplitterThickness(
        TDocumentFlowCommonControlStyles.GetSplitterThickness
      )
      .SectionContentSplitterColor(
        TDocumentFlowCommonControlStyles.GetSplitterColor
      )
      .Color(
        TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor
      );

  FUIControlsTrackingStylist.TrackUIControlTypeForStylization(
    TDocumentFlowAdministrationForm, AdministrationFormStyle
  );

end;

constructor TUIApplicationConfigurator.Create;
begin

  inherited;

  FApplicationConfigurator := TApplicationConfigurator.Create;
  FUIControlsTrackingStylist := TUIControlsTrackingStylist.Create;
  FUIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;

end;

procedure TUIApplicationConfigurator.CreateApplicationMainForm(
  ConfigurationData: TConfigurationData
);
var
    DocumentKindsFrame: TDocumentKindsFrame;
    DocumentCardListFrame: TDocumentCardListFrame;
    ApplicationMainFormCaption: String;
begin

  DocumentKindsFrame := TDocumentKindsFrame.Create(Application, False, True);

  DocumentCardListFrame := TDocumentCardListFrame.Create(Application);

  DocumentCardListFrame.DocumentsReferenceFormFactory :=
    TDocumentsReferenceFormFactory.Create(
      TEmployeeDocumentsReferenceFormProcessorFactory.Create(
        TStandardUIDocumentKindMapper.Create
      )
    );

  DocumentCardListFrame.DocumentsReferenceViewModelFactory :=
    TDocumentsReferenceViewModelFactory.Create;

  DocumentCardListFrame.DocumentsReferenceFormPresenter :=
    TStandardDocumentsReferenceFormPresenter.Create;

  ApplicationMainFrame :=
    TApplicationMainFrame.Create(
      Application, DocumentKindsFrame, DocumentCardListFrame, False, True
    );

  ApplicationMainFrame.WorkingEmployeeId := TWorkingEmployee.Current.Id;

  ApplicationMainFormCaption :=
    Format(
      'Электронный документооборот - "%s", таб.номер: %s',
      [
        TWorkingEmployee.Current.Surname + ' ' +
        TWorkingEmployee.Current.Name + ' ' +
        TWorkingEmployee.Current.Patronymic,
        TWorkingEmployee.Current.PersonnelNumber
      ]
    );

  Application.CreateForm(TApplicationMainForm, ApplicationMainForm);

  ApplicationMainForm.Caption := ApplicationMainFormCaption;
  ApplicationMainForm.ApplicationMainFrame := ApplicationMainFrame;
  
  ApplicationMainForm.ApplicationSettignsResetService :=
    TStandardApplicationSettingsResetService.Create(
      TApplicationPropertiesStorageRegistry.Current
    );

  TDocumentCardFrameFactories.Current := TDocumentCardFrameFactories.Create;

  ApplicationMainFrame.OnLayoutReadyEventHandler :=
    OnMainFrameLayoutReadyHandler;

end;

procedure TUIApplicationConfigurator.ConfigureDocumentDataSetHoldersFactories;
begin

  TDocumentDataSetHoldersFactories.Instance.SetDocumentDataSetHoldersFactory(
    TUIDocumentKind,
    TDocumentDataSetHoldersFactory.Create(
      TMemTableEhBuilderFactory.Create
      //TClientDataSetBuilderFactory.Create
    )
  );
  
end;

destructor TUIApplicationConfigurator.Destroy;
begin

  FreeAndNil(FApplicationConfigurator);
  FreeAndNil(FUIControlsTrackingStylist);
  
  inherited;

end;

procedure TUIApplicationConfigurator.OnMainFrameLayoutReadyHandler(
  ASender: TObject);
var
  VersionInfoForm: TVersionInfosForm;
  VersionInfoService: IApplicationVersionInfoService;
  VersionsDTOs: TVersionInfoDTOs;
begin

  VersionInfoService :=
    TApplicationServiceRegistries.Current.
      GetNotificationRegistry.
        GetApplicationVersionInfoService;

  VersionsDTOs := VersionInfoService.GetLastVersionChanges;

  if VersionsDTOs <> nil then
  begin

    VersionInfoForm :=
      TVersionInfosForm.Create(
          ASender as TComponent,
          VersionsDTOs
        );

    VersionInfoForm.ShowModal;

    VersionInfoService.WriteLastVersionToFile;
    
  end;

end;

end.
