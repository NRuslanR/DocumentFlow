unit StandardDocumentsReferenceFormPresenter;

interface

uses

  DocumentsReferenceFormPresenter,
  PlantItemService,
  OperationalDocumentKindInfo,
  Controls,
  SysUtils;

type

  TStandardDocumentsReferenceFormPresenter =
    class (TInterfacedObject, IDocumentsReferenceFormPresenter)

      private

        procedure ShowSDItemControl(
          DocumentFlowPrimaryScreen: TWinControl;
          const SDItemId: Variant
        );

        procedure ShowPlantItemControl(
          DocumentFlowPrimaryScreen: TWinControl;
          const PlantItemId: Variant
        );

        procedure SetDocumentPanelsVisible(
          DocumentFlowPrimaryScreen: TWinControl;
          const PanelsVisible: Boolean
        );

      private

        procedure InflateControlToDocumentFlowPrimaryScreen(
          Control: TControl;
          DocumentFlowPrimaryScreen: TWinControl
        );

        procedure HideAllNonDocumentFlowForms(
          DocumentFlowPrimaryScreen: TWinControl
        );

      public

        procedure ShowDocumentsReferenceForm(
          DocumentFlowPrimaryScreen: TWinControl;
          const DocumentKindInfo: IOperationalDocumentKindInfo
        );

    end;
  
implementation

uses

  Forms,
  Classes,
  ExtCtrls,
  SDBaseTableFormUnit,
  SDItemsService,
  UIDocumentKinds,
  UnPodrTree,
  AuxWindowsFunctionsUnit,
  ApplicationServiceRegistries,
  unDocumentCardListFrame,
  BaseDocumentsReferenceFormUnit, PresentationServiceRegistry;


{ TStandardDocumentsReferenceFormPresenter }

procedure TStandardDocumentsReferenceFormPresenter.SetDocumentPanelsVisible(
  DocumentFlowPrimaryScreen: TWinControl;
  const PanelsVisible: Boolean
);
begin

  with TDocumentCardListFrame(DocumentFlowPrimaryScreen)
  do begin

    SetDocumentAreasVisible(PanelsVisible);

  end;

end;

procedure TStandardDocumentsReferenceFormPresenter.
  ShowDocumentsReferenceForm(
    DocumentFlowPrimaryScreen: TWinControl;
    const DocumentKindInfo: IOperationalDocumentKindInfo
  );

begin

  with
    DocumentFlowPrimaryScreen as TDocumentCardListFrame
  do begin

    HideAllNonDocumentFlowForms(DocumentFlowPrimaryScreen);
    
    if DocumentKindInfo.UIDocumentKind.InheritsFrom(TUINativeDocumentKind)
    then begin

      SetDocumentPanelsVisible(DocumentFlowPrimaryScreen, True);

      ShowEmployeeDocumentReferenceFormForDocumentKind(DocumentKindInfo.UIDocumentKind)

    end

    else if DocumentKindInfo.UIDocumentKind = TUISDDocumentKind then begin

      ShowSDItemControl(DocumentFlowPrimaryScreen, DocumentKindInfo.WorkingDocumentKindId);

    end

    else if DocumentKindInfo.UIDocumentKind = TUIPlantDocumentKind then begin

      ShowPlantItemControl(DocumentFlowPrimaryScreen, DocumentKindInfo.WorkingDocumentKindId);
      
    end;

  end;

end;

procedure TStandardDocumentsReferenceFormPresenter.ShowPlantItemControl(
  DocumentFlowPrimaryScreen: TWinControl; const PlantItemId: Variant);
var
    PlantItemService: IPlantItemService;
    PlantItemControl: TControl;
begin

  TDocumentCardListFrame(DocumentFlowPrimaryScreen).RemoveDocumentAreas;

  PlantItemService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetPlantItemService;


  PlantItemControl :=
    PlantItemService.GetPlantItemControl(
      TDocumentCardListFrame(DocumentFlowPrimaryScreen).WorkingEmployeeId,
      PlantItemId
    );
  
  InflateControlToDocumentFlowPrimaryScreen(PlantItemControl, DocumentFlowPrimaryScreen);
  
end;

procedure TStandardDocumentsReferenceFormPresenter.ShowSDItemControl(
  DocumentFlowPrimaryScreen: TWinControl;
  const SDItemId: Variant
);
var
    SDItemsService: ISDItemsService;
    SDItemControl: TSDBaseTableForm;
begin

  TDocumentCardListFrame(DocumentFlowPrimaryScreen).RemoveDocumentAreas;
  
  SDItemsService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetSDItemsService;

  SDItemControl := TSDBaseTableForm(SDItemsService.GetSDItemControl(SDItemId));

  InflateControlToDocumentFlowPrimaryScreen(SDItemControl, DocumentFlowPrimaryScreen);

end;

procedure TStandardDocumentsReferenceFormPresenter.InflateControlToDocumentFlowPrimaryScreen(
  Control: TControl;
  DocumentFlowPrimaryScreen: TWinControl
);
var
    Form: TForm;
begin

  with TDocumentCardListFrame(DocumentFlowPrimaryScreen)
  do begin

    Control.Parent := PanelForDocumentRecordsAndCard;
    Control.Align := alClient;

    if Control is TForm then begin

      Form := TForm(Control);

      Form.BorderStyle := bsNone;
      Form.Font := Font;
      
    end;

    Control.Show;

  end;

end;

procedure TStandardDocumentsReferenceFormPresenter.HideAllNonDocumentFlowForms(
  DocumentFlowPrimaryScreen: TWinControl
);
var
    ControlPointers: TList;
    ControlPointer: Pointer;
begin

  with TDocumentCardListFrame(DocumentFlowPrimaryScreen) do begin

    ControlPointers := FindChildControlsByTypes(PanelForDocumentRecordsAndCard, [TSDBaseTableForm, TfrmPodrTree]);

    if not Assigned(ControlPointers) then Exit;
    
    for ControlPointer in ControlPointers do begin

      with TControl(ControlPointer) do begin

        Hide;
        Parent := nil;

      end;

    end;

  end;

end;

end.
