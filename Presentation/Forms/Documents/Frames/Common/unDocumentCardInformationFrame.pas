unit unDocumentCardInformationFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentFlowCardInformationFrame, ExtCtrls, DocumentKinds, UIDocumentKinds;

type

  TDocumentCardInformationFrame = class(TDocumentFlowCardInformationFrame)
  private

    FDocumentId: Variant;
    FServiceDocumentKind: TDocumentKindClass;
    FUIDocumentKind: TUIDocumentKindClass;

  protected

    procedure Initialize; override;
    
  protected

    function GetDocumentId: Variant; virtual;
    
    procedure SetDocumentId(const Value: Variant); virtual;
    procedure SetServiceDocumentKind(const Value: TDocumentKindClass); virtual;
    procedure SetUIDocumentKind(const Value: TUIDocumentKindClass); virtual;
    
  public
    
    property DocumentId: Variant
    read GetDocumentId write SetDocumentId;

    property ServiceDocumentKind: TDocumentKindClass
    read FServiceDocumentKind write SetServiceDocumentKind;

    property UIDocumentKind: TUIDocumentKindClass
    read FUIDocumentKind write SetUIDocumentKind;

  end;

var
  DocumentCardInformationFrame: TDocumentCardInformationFrame;

implementation

{$R *.dfm}

{ TDocumentCardInformationFrame }

function TDocumentCardInformationFrame.GetDocumentId: Variant;
begin

  Result := FDocumentId;
  
end;

procedure TDocumentCardInformationFrame.Initialize;
begin

  inherited Initialize;

  FDocumentId := Null;
  
  end;

procedure TDocumentCardInformationFrame.SetDocumentId(const Value: Variant);
begin

  FDocumentId := Value;
  
end;

procedure TDocumentCardInformationFrame.SetServiceDocumentKind(
  const Value: TDocumentKindClass);
begin

  FServiceDocumentKind := Value;
  
end;

procedure TDocumentCardInformationFrame.SetUIDocumentKind(
  const Value: TUIDocumentKindClass);
begin

  FUIDocumentKind := Value;

end;

end.
