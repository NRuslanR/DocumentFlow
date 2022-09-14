unit UIApplicationConfigurator;

interface

uses

  ConfigurationData,
  ApplicationConfigurator,
  IObjectPropertiesStorageRegistryUnit,
  DocumentApprovingSheetViewModelMapperFactories,
  UIControlsTrackingStylist,
  SysUtils,
  Classes;

type

  TUIApplicationConfigurator = class

    private

      FApplicationConfigurator: TApplicationConfigurator;
      FUIControlsTrackingStylist: TUIControlsTrackingStylist;
      
    private
      
      procedure ConfigureDocumentReportPresenterRegistry;

      procedure ConfigureApplicationPropertiesStorageRegistry;

      procedure ConfigureApplicationPropertiesIniFileRegistry(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String
      );

      procedure ConfigureDocumentDataSetHoldersFactories;

      procedure ConfigureDocumentCardFormViewModelFactories;
      
      procedure CustomizeDocumentsReferenceFormsPropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentChargesFramePropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentChargeSheetPerformersReferenceFormPropertiesIniFiles(
        const AppPropertiesDirPath: String;
        const DefaultAppPropertiesDirPath: String;
        ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
      );

      procedure CustomizeDocumentCardFramePropertiesIniFiles(
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

      procedure CreateApplicationMainForm(
        ConfigurationData: TConfigurationData
      );



      procedure OnMainFrameLayoutReadyHandler(ASender: TObject);

    private

      procedure ConfigureGlobalStylization;
      procedure ConfigureSDTableFormStyle;
      procedure ConfigureAdministrationFormStyle;

    private

      procedure ConfigureDocumentApprovingSheetViewModelMapperFactories;
      
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
  UIDocumentKinds,
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
  DocumentDataSetHolderFactories,
  DocumentKinds,
  DocumentCardFrameFactories,
  StandardUIDocumentKindMapper,
  unVersionInfosForm,
  ApplicationVersionInfoService,
  VersionInfoDTOs;

{ TUIApplicationConfigurator }

procedure TUIApplicationConfigurator.Configure(
  ConfigurationData: TConfigurationData);
begin

  FApplicationConfigurator.Configure(ConfigurationData);

  ConfigureDocumentDataSetHoldersFactories;
  ConfigureDocumentCardFormViewModelFactories;
  ConfigureDocumentReportPresenterRegistry;
  ConfigureApplicationPropertiesStorageRegistry;
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

  ApplicationPropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(

      TApplicationMainFrame,

      TApplicationMainFramePropertiesIniFile.Create(
        AppPropertiesDirPath + PathDelim + 'MainForm.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'MainForm.ini'
      )
    );
    
  CustomizeDocumentsReferenceFormsPropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeDocumentChargesFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeDocumentChargeSheetPerformersReferenceFormPropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeDocumentCardFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeDocumentKindsFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  CustomizeDocumentCardListFramePropertiesIniFiles(
    AppPropertiesDirPath,
    DefaultAppPropertiesDirPath,
    ApplicationPropertiesIniFilesRegistry
  );

  ConfigureDocumentApprovingSheetViewModelMapperFactories;

  ApplicationPropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(
      TDocumentRecordsPanelSettingsForm,
      TDocumentRecordsPanelSettingsFormPropertiesIniFile.Create(
        AppPropertiesDirPath + PathDelim + 'document_records_panel_settings_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'document_records_panel_settings_form.ini'
      )
        
    );
end;

procedure TUIApplicationConfigurator.CustomizeDocumentsReferenceFormsPropertiesIniFiles(
  const AppPropertiesDirPath: String;
  const DefaultAppPropertiesDirPath: String;
  ApplicationPropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
);
begin

  ApplicationPropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(

      TOutcomingServiceNotesReferenceForm,

      TDocumentsReferenceFormPropertiesIniFile.Create(

        TDocumentsReferenceFilterFormStatePropertiesIniFile.
          Create(
            AppPropertiesDirPath + PathDelim + 'employee_documents_form_filter_state.ini',
            DefaultAppPropertiesDirPath + PathDelim + 'employee_documents_form_filter_state.ini'
          ),

        AppPropertiesDirPath + PathDelim + 'employee_documents_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'employee_documents_form.ini'
      ),

      RegisterWithoutInheritanceCheckingOption
    );

  ApplicationPropertiesIniFilesRegistry.
    RegisterObjectPropertiesStorageForObjectClass(

      TIncomingServiceNotesReferenceForm,

      TDocumentsReferenceFormPropertiesIniFile.Create(

        TDocumentsReferenceFilterFormStatePropertiesIniFile.Create(
          AppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form_filter_state.ini',
          DefaultAppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form_filter_state.ini'
        ),
        
        AppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'employee_in_service_notes_form.ini'
      )
    );

  ApplicationPropertiesIniFilesRegistry
    .RegisterObjectPropertiesStorageForObjectClass(
    
      TApproveableServiceNotesReferenceForm,

      TDocumentsReferenceFormPropertiesIniFile.Create(

        TDocumentsReferenceFilterFormStatePropertiesIniFile.Create(
          AppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_filter_form_state.ini',
          DefaultAppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_filter_form_state.ini'
        ),
        
        AppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_form.ini',
        DefaultAppPropertiesDirPath + PathDelim + 'employee_approveable_service_notes_form.ini'
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
      TDocumentDataSetHolderFactories.Instance
    );
    
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

procedure TUIApplicationConfigurator.ConfigureGlobalStylization;
var
   DBDataTableFormStyle: TDBDataTableFormStyle;
begin

  ConfigureSDTableFormStyle;
  ConfigureAdministrationFormStyle;
  
  FUIControlsTrackingStylist.RunTracking;

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

  TDocumentDataSetHolderFactories.Instance.SetDocumentDataSetHolderFactory(
    TUIDocumentKind,
    TDocumentDataSetHoldersFactory.Create(
      TMemTableEhBuilder.Create
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

procedure TUIApplicationConfigurator.
  CustomizeDocumentCardFramePropertiesIniFiles(
    const AppPropertiesDirPath: String;
    const DefaultAppPropertiesDirPath: String;
    PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
  );
begin

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    TDocumentCardFrame,
    TDocumentCardFramePropertiesIniFile.Create(
      AppPropertiesDirPath + PathDelim + 'DocumentCardFrame.ini',
      DefaultAppPropertiesDirPath + PathDelim + 'DocumentCardFrame.ini'
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

procedure TUIApplicationConfigurator.
  CustomizeDocumentChargesFramePropertiesIniFiles(
    const AppPropertiesDirPath: String;
    const DefaultAppPropertiesDirPath: String;
    PropertiesIniFilesRegistry: IObjectPropertiesStorageRegistry
  );
begin

  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    TDocumentChargeSheetsFrame,
    TDocumentChargesFramePropertiesIniFile.Create(
      AppPropertiesDirPath + PathDelim + 'IncomingDocumentChargesFrame.ini',
      DefaultAppPropertiesDirPath + PathDelim + 'IncomingDocumentChargesFrame.ini'
    )
  );
  
  PropertiesIniFilesRegistry.RegisterObjectPropertiesStorageForObjectClass(
    TDocumentChargesFrame,
    TDocumentChargesFramePropertiesIniFile.Create(
      AppPropertiesDirPath + PathDelim + 'DocumentChargesFrame.ini',
      DefaultAppPropertiesDirPath + PathDelim + 'DocumentChargesFrame.ini'
    )
  );
  
end;

procedure TUIApplicationConfigurator.CustomizeDocumentChargeSheetPerformersReferenceFormPropertiesIniFiles(
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

end.
