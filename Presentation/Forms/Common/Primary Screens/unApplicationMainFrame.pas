unit unApplicationMainFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentFlowWorkingFrame, ExtCtrls, unDocumentKindsFrame,
  unDocumentCardListFrame, unSelectionDocumentCardListFrame,
  unSelectionDocumentsWorkingFrame, unScrollableFrame,
  unDocumentFlowInformationFrame;

type
  TApplicationMainFrame = class(TDocumentFlowWorkingFrame)
  
  {private refactor} public

    procedure OnRelatedDocumentSelectionFormRequestedEventHandler(
      Sender: TObject;
      var RelatedDocumentSelectionForm: TForm
    );
    
  public

    destructor Destroy; override;
    
    constructor Create(
      AOwner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      DocumentCardListFrame: TDocumentCardListFrame
    ); overload;

    constructor Create(
      AOwner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      DocumentCardListFrame: TDocumentCardListFrame;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean
    ); overload;
    
  end;

var
  ApplicationMainFrame: TApplicationMainFrame;

implementation

{$R *.dfm}

uses

  unSelectionDocumentsForm,
  AuxWindowsFunctionsUnit;

{ TApplicationMainFrame }

constructor TApplicationMainFrame.Create(
  AOwner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  DocumentCardListFrame: TDocumentCardListFrame
);
begin

  Create(AOwner, DocumentKindsFrame, DocumentCardListFrame, True, True);
    
end;

constructor TApplicationMainFrame.Create(AOwner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  DocumentCardListFrame: TDocumentCardListFrame;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean
);
begin

  inherited Create(
    AOwner,
    DocumentKindsFrame,
    DocumentCardListFrame,
    RestoreUIControlPropertiesOnCreate,
    SaveUIControlPropertiesOnDestroy
  );


  DocumentCardListFrame.OnRelatedDocumentSelectionFormRequestedEventHandler :=
    OnRelatedDocumentSelectionFormRequestedEventHandler;
    
end;

destructor TApplicationMainFrame.Destroy;
begin

  inherited;

end;

procedure TApplicationMainFrame.OnRelatedDocumentSelectionFormRequestedEventHandler(
  Sender: TObject;
  var RelatedDocumentSelectionForm: TForm
);
var
    SelectionDocumentKindsFrame: TDocumentKindsFrame;
    SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;
    SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame;
begin

  SelectionDocumentKindsFrame := nil;
  SelectionDocumentCardListFrame := nil;
  RelatedDocumentSelectionForm := nil;

  try
  
    SelectionDocumentKindsFrame :=
      TDocumentKindsFrame.Create(
        Self,
        DocumentKindsFrame.RestoreUIControlPropertiesOnCreate,
        DocumentKindsFrame.SaveUIControlPropertiesOnDestroy
      );

    SelectionDocumentCardListFrame :=
      TSelectionDocumentCardListFrame.Create(
        Self,
        DocumentCardListFrame.RestoreUIControlPropertiesOnCreate,
        DocumentCardListFrame.SaveUIControlPropertiesOnDestroy
      );

    SelectionDocumentCardListFrame.DocumentsReferenceFormFactory :=
      DocumentCardListFrame.DocumentsReferenceFormFactory;

    SelectionDocumentCardListFrame.DocumentsReferenceViewModelFactory :=
      DocumentCardListFrame.DocumentsReferenceViewModelFactory;

    SelectionDocumentCardListFrame.DocumentsReferenceFormPresenter :=
      DocumentCardListFrame.DocumentsReferenceFormPresenter;

    SelectionDocumentsWorkingFrame :=
      TSelectionDocumentsWorkingFrame.Create(
        Self,
        SelectionDocumentKindsFrame,
        SelectionDocumentCardListFrame,
        RestoreUIControlPropertiesOnCreate,
        SaveUIControlPropertiesOnDestroy
      );

    SelectionDocumentsWorkingFrame.Font := Font;

    if not SelectionDocumentsWorkingFrame.RestoreUIControlPropertiesOnCreate
    then SelectionDocumentsWorkingFrame.RestoreUIControlProperties;

    SelectionDocumentsWorkingFrame.WorkingEmployeeId := WorkingEmployeeId;

    RelatedDocumentSelectionForm :=
      TSelectionDocumentsForm.Create(Self, SelectionDocumentsWorkingFrame);

    RelatedDocumentSelectionForm.Caption := 'Выбор документов';

    SetControlSizeByOtherControlSize(
      RelatedDocumentSelectionForm, Self, 6 / 7, 6 / 7
    );

    RelatedDocumentSelectionForm.Position := poMainFormCenter;

    RelatedDocumentSelectionForm.Font := Font;

    SelectionDocumentKindsFrame.CurrentDocumentKindId :=
      DocumentKindsFrame.CurrentDocumentKindId;

  except

    on E: Exception do begin

      FreeAndNil(SelectionDocumentKindsFrame);
      FreeAndNil(SelectionDocumentCardListFrame);
      FreeAndNil(SelectionDocumentsWorkingFrame);
      FreeAndNil(RelatedDocumentSelectionForm);
      
    end;

  end;

end;

end.
