unit unSelectionDocumentsWorkingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentFlowWorkingFrame, ExtCtrls,
  unSelectionDocumentCardListFrame, unDocumentKindsFrame,
  DocumentRecordViewModel;

type
  TSelectionDocumentsWorkingFrame = class(TDocumentFlowWorkingFrame)

  private

    function GetSelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;
    function GetSelectedDocumentRecords: TDocumentRecordViewModels;
  
  public

    constructor Create(
      Owner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame
    ); overload;

    constructor Create(
      Owner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean
    ); overload;

  public

    property DocumentCardListFrame: TSelectionDocumentCardListFrame
    read GetSelectionDocumentCardListFrame;

    property SelectedDocumentRecords: TDocumentRecordViewModels
    read GetSelectedDocumentRecords;

  end;

implementation

{$R *.dfm}

{ TSelectionDocumentWorkingFrame }

constructor TSelectionDocumentsWorkingFrame.Create(
  Owner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame
);
begin

  Create(Owner, DocumentKindsFrame, SelectionDocumentCardListFrame, True, True);
  
end;

constructor TSelectionDocumentsWorkingFrame.Create(Owner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean
);
begin

  inherited Create(
    Owner,
    DocumentKindsFrame,
    SelectionDocumentCardListFrame,
    RestoreUIControlPropertiesOnCreate,
    SaveUIControlPropertiesOnDestroy
  );

end;

function TSelectionDocumentsWorkingFrame.GetSelectedDocumentRecords: TDocumentRecordViewModels;
begin

  if Assigned(DocumentCardListFrame) then
    Result := DocumentCardListFrame.SelectedDocumentRecords

  else Result := nil;
  
end;

function TSelectionDocumentsWorkingFrame.
  GetSelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;
begin

  Result := TSelectionDocumentCardListFrame(inherited DocumentCardListFrame);
  
end;

end.
