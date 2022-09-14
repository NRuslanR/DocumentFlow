unit DocumentCardFramePropertiesStorage;

interface

uses

  unDocumentFlowInformationFrame,
  StandardDefaultObjectPropertiesStorage,
  StandardDocumentFlowInformationFramePropertiesStorage,
  IPropertiesStorageUnit,
  IObjectPropertiesStorageUnit,
  UserInterfaceSwitch,
  unDocumentCardFrame;

const

  DOCUMENT_MAIN_INFORMATION_AND_RECEIVERS_FORM_SIZE_RATIO =
    'DocumentMainInformationAndReceiversFormSizeRatio';

  RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO =
    'RelatedDocumentsAndFilesFormSizeRatio';

  NEW_UI_RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO =
    'NewUIRelatedDocumentsAndFilesFormSizeRatio';

  NEW_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO =
    'NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio';

  OLD_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO =
    'OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio';
    
  DOCUMENT_CARD_UI_KIND = 'UserInterfaceKind';

  NEW_DOCUMENT_CARD_UI_LAST_SELECTED_CARD_SHEET_INDEX =
    'NewUserInterfaceSelectedDocumentCardSheetIndex';
    
  LAST_SELECTED_DOCUMENT_CARD_SHEET_INDEX =
    'LastSelectedDocumentCardSheetIndex';

type

  TDocumentCardFramePropertiesStorage =
    class abstract (TStandardDocumentFlowInformationFramePropertiesStorage)

      protected

        procedure InternalSaveObjectProperties(
          TargetObject: TObject;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure InternalRestorePropertiesForObject(
          TargetObject: TObject;
          PropertiesStorage: IPropertiesStorage
        ); override;

      protected

        procedure InternalRestoreFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure InternalSaveFramePropertiesForUserInterfaceKind(
          Frame: TDocumentFlowInformationFrame;
          UserInterfaceKind: TUserInterfaceKind;
          PropertiesStorage: IPropertiesStorage
        ); override;
        
      protected

        procedure SaveDocumentCardFrameProperties(
          DocumentCardFrame: TDocumentCardFrame;
          PropertiesStorage: IPropertiesStorage
        );

        procedure RestoreDocumentCardFrameProperties(
          DocumentCardFrame: TDocumentCardFrame;
          PropertiesStorage: IPropertiesStorage
        );

    end;

implementation

uses

  AuxDebugFunctionsUnit,
  VariantFunctions,
  StandardObjectPropertiesStorage;

{ TDocumentCardFramePropertiesStorage }

procedure TDocumentCardFramePropertiesStorage.InternalRestorePropertiesForObject(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  RestoreDocumentCardFrameProperties(
    TargetObject as TDocumentCardFrame,
    PropertiesStorage
  );

end;

procedure TDocumentCardFramePropertiesStorage.InternalSaveObjectProperties(
  TargetObject: TObject; PropertiesStorage: IPropertiesStorage);
begin

  SaveDocumentCardFrameProperties(
    TargetObject as TDocumentCardFrame,
    PropertiesStorage
  );

end;

procedure TDocumentCardFramePropertiesStorage.RestoreDocumentCardFrameProperties(
  DocumentCardFrame: TDocumentCardFrame;
  PropertiesStorage: IPropertiesStorage
);
begin

  PropertiesStorage.GoToSection('UI Settings');

  if FDefaultPropertiesStorage <> PropertiesStorage then begin

    DocumentCardFrame.UserInterfaceKind :=
      PropertiesStorage.ReadValueForProperty(
        DOCUMENT_CARD_UI_KIND,
        varInteger,
        uiOld
      );

  end;

  InternalRestoreFramePropertiesForUserInterfaceKind(
    DocumentCardFrame,
    DocumentCardFrame.UserInterfaceKind,
    PropertiesStorage
  );

end;

procedure TDocumentCardFramePropertiesStorage.SaveDocumentCardFrameProperties(
  DocumentCardFrame: TDocumentCardFrame;
  PropertiesStorage: IPropertiesStorage
);
var
    UserInterfaceKind: TUserInterfaceKind;
begin

  PropertiesStorage.GoToSection('UI Settings');

  UserInterfaceKind := DocumentCardFrame.UserInterfaceKind;

  PropertiesStorage.WriteValueForProperty(
    DOCUMENT_CARD_UI_KIND,
    UserInterfaceKind
  );

  InternalSaveFramePropertiesForUserInterfaceKind(
    DocumentCardFrame,
    UserInterfaceKind,
    PropertiesStorage
  );

end;

procedure TDocumentCardFramePropertiesStorage.InternalRestoreFramePropertiesForUserInterfaceKind(
  Frame: TDocumentFlowInformationFrame;
  UserInterfaceKind: TUserInterfaceKind;
  PropertiesStorage: IPropertiesStorage
);
var
    DocumentCardFrame: TDocumentCardFrame;
    DocumentMainInformationAndReceiversFormSizeRatio: Double;
    NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    RelatedDocumentsAndFilesFormSizeRatio: Double;
    NewUIRelatedDocumentsAndFilesFormSizeRatio: Double;
    LastSelectedDocumentCardSheetIndex: Integer;
begin

  DocumentCardFrame := Frame as TDocumentCardFrame;

  PropertiesStorage.GoToSection('UI Settings');

  DocumentMainInformationAndReceiversFormSizeRatio :=
    PropertiesStorage.ReadValueForProperty(
      DOCUMENT_MAIN_INFORMATION_AND_RECEIVERS_FORM_SIZE_RATIO,
      varDouble,
      0
    );

  RelatedDocumentsAndFilesFormSizeRatio :=
    PropertiesStorage.ReadValueForProperty(
      RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO,
      varDouble,
      0
    );

  NewUIRelatedDocumentsAndFilesFormSizeRatio :=
    PropertiesStorage.ReadValueForProperty(
      NEW_UI_RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO,
      varDouble,
      0
    );

  OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    PropertiesStorage.ReadValueForProperty(
      OLD_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO,
      varDouble,
      0
    );

  NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
    PropertiesStorage.ReadValueForProperty(
      NEW_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO,
      varDouble,
      0
    );

  case UserInterfaceKind of

    uiOld:
    begin

      if
        (DocumentMainInformationAndReceiversFormSizeRatio = 0)
        and (RelatedDocumentsAndFilesFormSizeRatio = 0)

      then Exit;
      
    end;

    uiNew:
    begin

      if
        (NewUIRelatedDocumentsAndFilesFormSizeRatio = 0)
        and (NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio = 0)
      then Exit;

    end;

  end;

  DocumentCardFrame.SaveUIControlPropertiesEnabled := False;

  case UserInterfaceKind of

    uiOld:
    begin

      DocumentCardFrame.ActiveDocumentInfoPageNumber :=
        PropertiesStorage.ReadValueForProperty(
          LAST_SELECTED_DOCUMENT_CARD_SHEET_INDEX,
          varInteger,
          0
        );

      DocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio :=
        RelatedDocumentsAndFilesFormSizeRatio;

      DocumentCardFrame.OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
        OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

      DocumentCardFrame.MainInformationAndReceiversFormSizeRatio :=
        DocumentMainInformationAndReceiversFormSizeRatio;

    end;

    uiNew:
    begin

      if PropertiesStorage = FDefaultPropertiesStorage then begin

        NewUIRelatedDocumentsAndFilesFormSizeRatio := 1;
        NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 0.5;
        LastSelectedDocumentCardSheetIndex := 0;
        
      end

      else begin

        LastSelectedDocumentCardSheetIndex :=
          PropertiesStorage.ReadValueForProperty(
            NEW_DOCUMENT_CARD_UI_LAST_SELECTED_CARD_SHEET_INDEX,
            varInteger,
            0
          );

      end;

      DocumentCardFrame.ActiveDocumentInfoPageNumber := LastSelectedDocumentCardSheetIndex;

      DocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio :=
        NewUIRelatedDocumentsAndFilesFormSizeRatio;

      DocumentCardFrame.NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
        NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

    end;


  end;

  DocumentCardFrame.SaveUIControlPropertiesEnabled := True;

end;

procedure TDocumentCardFramePropertiesStorage.InternalSaveFramePropertiesForUserInterfaceKind(
  Frame: TDocumentFlowInformationFrame;
  UserInterfaceKind: TUserInterfaceKind;
  PropertiesStorage: IPropertiesStorage
);
var
    RelatedDocumentsAndFilesFormSizeRatio: Double;
    NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;
    NewUILastSelectedCardSheetIndex: Integer;
    OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio: Double;

    DocumentCardFrame: TDocumentCardFrame;
begin

  DocumentCardFrame := Frame as TDocumentCardFrame;
  
  PropertiesStorage.GoToSection('UI Settings');

  case UserInterfaceKind of

    uiOld:
    begin

{      if FDefaultPropertiesStorage = PropertiesStorage then begin

        OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 0.5;

      end

      else begin     }

        OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
          DocumentCardFrame.OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

//      end;

      PropertiesStorage.WriteValueForProperty(
        RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO,
        DocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio
      );

      PropertiesStorage.WriteValueForProperty(
        DOCUMENT_MAIN_INFORMATION_AND_RECEIVERS_FORM_SIZE_RATIO,
        DocumentCardFrame.MainInformationAndReceiversFormSizeRatio
      );

      PropertiesStorage.WriteValueForProperty(
        OLD_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO,
        OldUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
      );

      if
        (DocumentCardFrame.ActiveDocumentInfoPageNumber = 0)
        and (
        PropertiesStorage
          .ReadValueForProperty(
            LAST_SELECTED_DOCUMENT_CARD_SHEET_INDEX,
            varInteger,
            -1
          ) = 1)
      then   begin

        DebugOutput('dadsadas');
        
      end;
      
      PropertiesStorage.WriteValueForProperty(
        LAST_SELECTED_DOCUMENT_CARD_SHEET_INDEX,
        DocumentCardFrame.ActiveDocumentInfoPageNumber
      );

    end;

    uiNew:
    begin

      if FDefaultPropertiesStorage = PropertiesStorage then begin

        RelatedDocumentsAndFilesFormSizeRatio := 1;
        NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 0.5;
        NewUILastSelectedCardSheetIndex := 0;

      end

      else begin

        RelatedDocumentsAndFilesFormSizeRatio :=
          DocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio;

        NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
          DocumentCardFrame.NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

        NewUILastSelectedCardSheetIndex :=
          DocumentCardFrame.ActiveDocumentInfoPageNumber;
          
      end;



      PropertiesStorage.WriteValueForProperty(
        NEW_UI_RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO,
        RelatedDocumentsAndFilesFormSizeRatio
      );

      PropertiesStorage.WriteValueForProperty(
        NEW_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO,
        NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
      );

      PropertiesStorage.WriteValueForProperty(
        NEW_DOCUMENT_CARD_UI_LAST_SELECTED_CARD_SHEET_INDEX,
        NewUILastSelectedCardSheetIndex
      );

    end;

  end;

{  if FDefaultPropertiesStorage = PropertiesStorage then begin

    RelatedDocumentsAndFilesFormSizeRatio := 1;
    NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio := 0.5;

  end

  else begin

    RelatedDocumentsAndFilesFormSizeRatio :=
      DocumentCardFrame.RelatedDocumentsAndFilesFormSizeRatio;

    NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio :=
      DocumentCardFrame.NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio;

//  end;


  PropertiesStorage.WriteValueForProperty(
    NEW_UI_RELATED_DOCUMENTS_AND_FILES_FORM_SIZE_RATIO,
    RelatedDocumentsAndFilesFormSizeRatio
  );

  PropertiesStorage.WriteValueForProperty(
    NEW_UI_RELATED_DOCUMENTS_AND_FILES_PANEL_AND_FILES_PREVIEW_PANEL_SIZE_RATIO,
    NewUIRelatedDocumentsAndFilesPanelAndFilesPreviewPanelSizeRatio
  );

  }

end;


end.
