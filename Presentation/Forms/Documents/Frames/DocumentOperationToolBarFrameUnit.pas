unit DocumentOperationToolBarFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, cxButtons;

type

  TDocumentOperationToolActivateEventHandler =
    procedure (Sender: TObject) of object;

  TDocumentOperationToolBarFrame = class(TFrame)
    ScrollBox: TScrollBox;
    DocumentOperationToolBar: TFlowPanel;

  private

    type

      TDefaultDocumentOperationEnum = (

        Saving = 0,
        SendingToSigning,
        PrintFormCreating,
        ApprovingSheetCreating,
        SendingToApproving,
        Approving,
        NotApproving,
        Signing,
        SigningMarking,
        SigningRejecting,
        Performing
        
      );

      TDefaultDocumentOperationToolArray = array of TButton;

  private

    FDefaultDocumentOperationToolArray: TDefaultDocumentOperationToolArray;

    procedure SaveDefaultDocumentOperationTool(
      const Operation: TDefaultDocumentOperationEnum;
      OperationTool: TButton
    );

    function GetDefaultDocumentOperationTool(
      const Operation: TDefaultDocumentOperationEnum
    ): TButton;

    function GetDocumentOperationToolByIndex(Index: Integer): TButton;
    function GetToolCount: Integer;
    
  public

    constructor Create(AOwner: TComponent); override;
    
    function CreateDocumentOperationTool(
      const Caption: String;
      const EventHandler: TDocumentOperationToolActivateEventHandler = nil
    ): TButton;

    function CreateDocumentSavingTool(const Caption: String): TButton;
    function CreateSigningDocumentSendingTool(const Caption: String): TButton;
    function CreateDocumentPrintFormCreatingTool(const Caption: String): TButton;
    function CreateDocumentApprovingSheetCreatingTool(const Caption: String): TButton;
    function CreateApprovingDocumentSendingTool(const Caption: String): TButton;
    function CreateDocumentApprovingTool(const Caption: String): TButton;
    function CreateDocumentNotApprovingTool(const Caption: String): TButton;
    function CreateDocumentSigningTool(const Caption: String): TButton;
    function CreateDocumentSigningMarkingTool(const Caption: String): TButton;
    function CreateDocumentSigningRejectingTool(const Caption: String): TButton;
    function CreateDocumentPerformingTool(const Caption: String): TButton;

    function GetDocumentSavingTool: TButton;
    function GetSigningDocumentSendingTool: TButton;
    function GetDocumentPrintFormCreatingTool: TButton;
    function GetDocumentApprovingSheetCreatingTool: TButton;
    function GetApprovingDocumentSendingTool: TButton;
    function GetDocumentApprovingTool: TButton;
    function GetDocumentNotApprovingTool: TButton;
    function GetDocumentSigningTool: TButton;
    function GetDocumentSigningMarkingTool: TButton;
    function GetDocumentSigningRejectingTool: TButton;
    function GetDocumentPerformingTool: TButton;

    function GetDocumentOperationToolByCaption(const Caption: String): TButton;
    procedure RemoveDocumentOperationToolByCaption(const Caption: String);

    property Tools[Index: Integer]: TButton
    read GetDocumentOperationToolByIndex;

    property ToolCount: Integer read GetToolCount;

  end;

implementation

uses

  CommonControlStyles,
  AuxWindowsFunctionsUnit;
  
{$R *.dfm}

{ TDocumentOperationToolBarFrame }

constructor TDocumentOperationToolBarFrame.Create(AOwner: TComponent);
var
    DocumentOperationCount: Integer;
begin

  inherited;

  TDocumentFlowCommonControlStyles.ApplyStylesToFrame(Self);

  DocumentOperationCount :=
    Ord(High(TDefaultDocumentOperationEnum)) -
    Ord(Low(TDefaultDocumentOperationEnum)) + 1;
    
  SetLength(FDefaultDocumentOperationToolArray, DocumentOperationCount);
  
end;

function TDocumentOperationToolBarFrame.CreateApprovingDocumentSendingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(SendingToApproving, Result);

end;

function TDocumentOperationToolBarFrame.CreateDocumentApprovingSheetCreatingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(ApprovingSheetCreating, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentApprovingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(Approving, Result);

end;

function TDocumentOperationToolBarFrame.CreateDocumentNotApprovingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(NotApproving, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentOperationTool(
  const Caption: String;
  const EventHandler: TDocumentOperationToolActivateEventHandler
): TButton;
begin

  Result := TcxButton.Create(DocumentOperationToolBar);

  Result.Parent := DocumentOperationToolBar;
  
  Result.Caption := Caption;

  Result.AlignWithMargins := True;
  
  Result.Margins.Left := 6;
  Result.Margins.Top := 5;
  Result.Margins.Right := 6;
  Result.Margins.Bottom := 5;

  TDocumentFlowCommonControlStyles.ApplyStylesToButton(Result);

  Result.OnClick := EventHandler;
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentPerformingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(Performing, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentPrintFormCreatingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(PrintFormCreating, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentSavingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(Saving, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentSigningMarkingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(SigningMarking, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentSigningRejectingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(SigningRejecting, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateDocumentSigningTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(Signing, Result);
  
end;

function TDocumentOperationToolBarFrame.CreateSigningDocumentSendingTool(
  const Caption: String): TButton;
begin

  Result := CreateDocumentOperationTool(Caption);

  SaveDefaultDocumentOperationTool(SendingToSigning, Result);
  
end;

function TDocumentOperationToolBarFrame.GetApprovingDocumentSendingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(SendingToApproving);

end;

function TDocumentOperationToolBarFrame.GetDefaultDocumentOperationTool(
  const Operation: TDefaultDocumentOperationEnum): TButton;
begin

  Result := FDefaultDocumentOperationToolArray[Integer(Operation)];

end;

function TDocumentOperationToolBarFrame.GetDocumentApprovingSheetCreatingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(ApprovingSheetCreating);
  
end;

function TDocumentOperationToolBarFrame.GetDocumentApprovingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(Approving);

end;

function TDocumentOperationToolBarFrame.GetDocumentNotApprovingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(NotApproving);

end;

function TDocumentOperationToolBarFrame.GetDocumentPerformingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(Performing);

end;

function TDocumentOperationToolBarFrame.GetDocumentPrintFormCreatingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(PrintFormCreating);
  
end;

function TDocumentOperationToolBarFrame.GetDocumentSavingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(Saving);
  
end;

function TDocumentOperationToolBarFrame.GetDocumentSigningMarkingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(SigningMarking);

end;

function TDocumentOperationToolBarFrame.GetDocumentSigningRejectingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(SigningRejecting);

end;

function TDocumentOperationToolBarFrame.GetDocumentSigningTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(Signing);
  
end;

function TDocumentOperationToolBarFrame.GetSigningDocumentSendingTool: TButton;
begin

  Result := GetDefaultDocumentOperationTool(SendingToSigning);

end;

function TDocumentOperationToolBarFrame.GetToolCount: Integer;
begin

  Result := DocumentOperationToolBar.ControlCount;
  
end;

function TDocumentOperationToolBarFrame.GetDocumentOperationToolByCaption(
  const Caption: String): TButton;
var ToolControl: TControl;
    I: Integer;
begin

  for I := 0 to DocumentOperationToolBar.ControlCount - 1 do begin

    ToolControl := DocumentOperationToolBar.Controls[I];

    if not (ToolControl is TButton) then Continue;

    if (ToolControl as TButton).Caption = Caption then begin

      Result := ToolControl as TButton;
      Exit;
      
    end;
    
  end;

  Result := nil;

end;

function TDocumentOperationToolBarFrame.
  GetDocumentOperationToolByIndex(
    Index: Integer
  ): TButton;
begin

  Result := DocumentOperationToolBar.Controls[Index] as TButton;

end;

procedure TDocumentOperationToolBarFrame.RemoveDocumentOperationToolByCaption(
  const Caption: String);
var Tool: TButton;
begin

  Tool := GetDocumentOperationToolByCaption(Caption);

  if Assigned(Tool) then
    Tool.Destroy;
    
end;

procedure TDocumentOperationToolBarFrame.SaveDefaultDocumentOperationTool(
  const Operation: TDefaultDocumentOperationEnum; OperationTool: TButton);
begin

  FDefaultDocumentOperationToolArray[Integer(Operation)] := OperationTool;
  
end;

end.
