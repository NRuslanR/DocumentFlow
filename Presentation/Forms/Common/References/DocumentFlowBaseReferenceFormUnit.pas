unit DocumentFlowBaseReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBDataTableFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxButtons, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, ToolWin, TableViewFilterFormUnit, cxCheckBox,
  cxLocalization, UserInterfaceSwitch;

type

  TDocumentFlowBaseReferenceForm = class(TDBDataTableForm, IUserInterfaceSwitch)
    procedure DataRecordGridTableViewCellDblClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure DataRecordGridTableViewCustomDrawColumnHeader(
      Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure DataRecordGridTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);

  private

    FWorkingEmployeeId: Variant;
    FUIControlPropertiesRestored: Boolean;

    FUserInterfaceKind: TUserInterfaceKind;

  private

    function GetUserInterfaceKind: TUserInterfaceKind;
    procedure SetUserInterfaceKind(Value: TUserInterfaceKind);

    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind); virtual;

  protected

    procedure SetDataSetFieldDefsReadOnly(
      DataSet: TDataSet;
      const ReadOnly: Boolean
    );

    procedure OnDataLoadingSuccessHandle(
      Sender: TObject;
      DataSet: TDataSet;
      RelatedState: TObject;
      const IsDestroyingRequested: Boolean
    ); override;
    
    procedure CustomizeTableViewFilterForm(ATableViewFilterForm: TTableViewFilterForm); override;

    function GetTotalRecordCountPanelLabel: String; override;
    procedure Init(const Caption: String; ADataSet: TDataSet); override;

  public
  
    procedure RestoreUIControlProperties; virtual;
    procedure SaveUIControlProperties; virtual;

    procedure RestoreDefaultUIControlProperties; virtual;
    procedure SaveDefaultUIControlProperties; virtual;

  public
    
    property UserInterfaceKind: TUserInterfaceKind
    read GetUserInterfaceKind write SetUserInterfaceKind;

  protected

    procedure SetViewOnly(const Value: Boolean); override;

  public

    destructor Destroy; override;
    
    constructor Create(AOwner: TComponent); override;

    property WorkingEmployeeId: Variant
    read FWorkingEmployeeId write FWorkingEmployeeId;
    
  end;

var
  DocumentFlowBaseReferenceForm: TDocumentFlowBaseReferenceForm;

implementation

uses
  AuxDebugFunctionsUnit,
  CommonControlStyles,
  ApplicationPropertiesStorageRegistry,
  IObjectPropertiesStorageUnit,
  DefaultObjectPropertiesStorage;

{$R *.dfm}

{ TDocumentInformationTableForm }

constructor TDocumentFlowBaseReferenceForm.Create(AOwner: TComponent);
begin

  inherited;

  FWorkingEmployeeId := Null;
  
end;


procedure TDocumentFlowBaseReferenceForm.CustomizeTableViewFilterForm(
  ATableViewFilterForm: TTableViewFilterForm);
begin

  ATableViewFilterForm.Caption :=
    'Отбор документов по требуемым реквизитам';

  ATableViewFilterForm.Color := clWhite;
  ATableViewFilterForm.Position := poScreenCenter;

end;

procedure TDocumentFlowBaseReferenceForm.DataRecordGridTableViewCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin

  actChooseRecords.Execute;

  AHandled := True;

end;

procedure TDocumentFlowBaseReferenceForm.DataRecordGridTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var  w: TcxCheckBox;
begin

  inherited;

end;

procedure TDocumentFlowBaseReferenceForm.DataRecordGridTableViewCustomDrawColumnHeader(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
begin

  inherited;
  
  AViewInfo.AlignmentHorz := taCenter;

end;

destructor TDocumentFlowBaseReferenceForm.Destroy;
var ObjectPropertiesStorage: IObjectPropertiesStorage;
begin

  SaveUIControlProperties;

  inherited;

end;

function TDocumentFlowBaseReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество документов: ';
  
end;

function TDocumentFlowBaseReferenceForm.GetUserInterfaceKind: TUserInterfaceKind;
begin

  Result := FUserInterfaceKind;
  
end;

procedure TDocumentFlowBaseReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
var
    Column: TcxGridDBColumn;
begin

  inherited;

  FocusedCellColor := $00c56a31;
  SelectedRecordsColor := $00c56a31;
  FocusedCellTextColor := $00ffffff;
  SelectedRecordsTextColor := $00ffffff;
  
  UserLoginPanelVisible := False;
  DatabaseNamePanelVisible := False;

  MustSaveFilterFormStateBeforeClosing := True;

  Color :=
    TDocumentFlowCommonControlStyles.GetFormBackgroundColor;
    
  DataOperationToolBar.GradientStartColor :=
    TDocumentFlowCommonControlStyles.GetTableFormToolBarGradientColorStart;

  DataOperationToolBar.GradientEndColor :=
    TDocumentFlowCommonControlStyles.GetTableFormToolBarGradientColorEnd;

  SaveDefaultUIControlProperties;
  RestoreUIControlProperties;

end;

procedure TDocumentFlowBaseReferenceForm.OnDataLoadingSuccessHandle(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject;
  const IsDestroyingRequested: Boolean
);
begin

  SetDataSetFieldDefsReadOnly(DataSet, False);

  inherited;

end;

procedure TDocumentFlowBaseReferenceForm.RestoreUIControlProperties;
var ObjectPropertiesStorage: IObjectPropertiesStorage;
begin

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then Exit;

  ObjectPropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.GetPropertiesStorageForObjectClass(ClassType);

  if Assigned(ObjectPropertiesStorage) then
    ObjectPropertiesStorage.RestorePropertiesForObject(Self);

end;

procedure TDocumentFlowBaseReferenceForm.SaveUIControlProperties;
var ObjectPropertiesStorage: IObjectPropertiesStorage;
begin

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then
    Exit;

  ObjectPropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.
        GetPropertiesStorageForObjectClass(Self.ClassType);

  if Assigned(ObjectPropertiesStorage) then
    ObjectPropertiesStorage.SaveObjectProperties(Self);

end;

procedure TDocumentFlowBaseReferenceForm.RestoreDefaultUIControlProperties;
var
    ObjectPropertiesStorage: IDefaultObjectPropertiesStorage;
begin

  if not FUIControlPropertiesRestored then begin

    SaveDefaultUIControlProperties;

    FUIControlPropertiesRestored := True;
    
  end;
  
  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then Exit;

  ObjectPropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.GetDefaultObjectPropertiesStorage(ClassType);

  if Assigned(ObjectPropertiesStorage) then
    ObjectPropertiesStorage.RestoreDefaultObjectProperties(Self);

end;

procedure TDocumentFlowBaseReferenceForm.SaveDefaultUIControlProperties;
var
    ObjectPropertiesStorage: IDefaultObjectPropertiesStorage;
begin

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then
    Exit;

  ObjectPropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.
        GetDefaultObjectPropertiesStorage(Self.ClassType);

  if Assigned(ObjectPropertiesStorage) then 
    ObjectPropertiesStorage.SaveDefaultObjectProperties(Self);
    
end;

procedure TDocumentFlowBaseReferenceForm.SetDataSetFieldDefsReadOnly(
  DataSet: TDataSet;
  const ReadOnly: Boolean
);
var
    Field: TField;
begin

  for Field in DataSet.Fields do begin

    Field.ReadOnly := ReadOnly;

  end;

end;

procedure TDocumentFlowBaseReferenceForm.SetUserInterfaceKind(
  Value: TUserInterfaceKind);
begin

  FUserInterfaceKind := Value;

  SwitchUserInterfaceTo(Value);
  
end;

procedure TDocumentFlowBaseReferenceForm.SetViewOnly(const Value: Boolean);
begin

  inherited;

  if Value then begin

    DataOperationToolBar.EdgeInner := esNone;
    DataOperationToolBar.EdgeOuter := esNone;
    
  end;
  
end;

procedure TDocumentFlowBaseReferenceForm.SwitchUserInterfaceTo(
  Value: TUserInterfaceKind);
begin

end;

end.
