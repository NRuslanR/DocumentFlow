unit BaseDocumentsReferenceFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TableViewFilterFormUnit, StdCtrls,
  cxGrid, cxGridDBTableView, cxGridCustomView, cxGridCommon, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxButtons;

const

  { refactor: получить наименование поля из DocumentSetHolder.
    Получать DocumentSetHolder из ViewModel передаваемого в конструктор
    EmployeeDocumentsReferenceForm экземпляра
  }
  CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN = 'current_work_cycle_stage_name';
  
type

  TBaseDocumentsReferenceFilterForm = class(TTableViewFilterForm)

    procedure OnDocumentWorkCycleStageComboBoxChange(Sender: TObject);

  private
    function GetSelectedDocumentWorkCycleStageNames: TStrings;
    procedure SetSelectedDocumentWorkCycleStageNames(const Value: TStrings);
    { Private declarations }

  protected

    FDocumentWorkCycleStageComboBox: TComboBox;
    FDocumentWorkCycleStageNames: TStrings;

    FSelectedDocumentWorkCycleStageNames: TStrings;

    procedure SaveCurrentState; override;
    class function GetTableViewFilterFormStateClass: TTableViewFilterFormStateClass; override;

    function GetDocumentWorkCycleStageNames: TStrings;
    procedure SetDocumentWorkCycleStageNames(const Value: TStrings);

    procedure SetDataSetFiltered(const Filtered: Boolean); override;

    procedure InternalSetLastState(ALastState: TTableViewFilterFormState); override;

    function CreateFilterFieldValueControl(
      Parent: TWinControl;
      const Field: TcxGridDBColumn
    ): TControl; override;

    function CreateFilterConditionsComboBox(
      ParentControl: TWinControl;
      FilterFieldValueControl: TControl;
      const Field: TcxGridDBColumn
    ): TComboBox; override;

    function CreateFilterFieldExpression(
      const ColumnField: TcxGridDBColumn;
      FilterConditionsComboBox: TComboBox;
      FilterFieldValueControl: TControl
    ): string; override;

    procedure AssignFilterPanelData(
      const ColumnField: TcxGridDBColumn;
      FilterFieldControls: TFilterFieldControls;
      FilterPanelData: TFilterPanelData
    ); override;

    function GetDisableFilterConditionIndicesByField(
      const ColumnField: TcxGridDBColumn
    ): TIntArray; override;

    function CreateCurrentFilterPanelDataFor(
      const ColumnField: TcxGridDBColumn;
      FilterFieldControls: TFilterFieldControls
    ): TFilterPanelData; override;
    
    function CreateAndFillDocumentWorkCycleStageComboBox(
      ParentControl: TWinControl
    ): TComboBox;

    procedure FillDocumentWorkCycleStageComboBox(
      DocumentWorkCycleStageComboBox: TComboBox
    );
    
  public
    { Public declarations }

    destructor Destroy; override;
    
  published

    property DocumentWorkCycleStageNames: TStrings
    read GetDocumentWorkCycleStageNames write SetDocumentWorkCycleStageNames;

    property SelectedDocumentWorkCycleStageNames: TStrings
    read GetSelectedDocumentWorkCycleStageNames write SetSelectedDocumentWorkCycleStageNames;

  end;

  TBaseDocumentReferenceFilterFormState = class(TTableViewFilterFormState)

    private
      FSelectedWorkCycleStageNames: TStrings;

    public

      property SelectedWorkCycleStageNames: TStrings
      read FSelectedWorkCycleStageNames;

      function ToDataSetFilter: String; override;
      function Clone: TTableViewFilterFormState; override;

  end;

var
  BaseDocumentsReferenceFilterForm: TBaseDocumentsReferenceFilterForm;

implementation

uses

  VariantTypeUnit;
  
{$R *.dfm}

procedure AddSelectedDocumentWorkCycleStageNamesFilterConditionTo(
      var FilterString: String;
      const SelectedDocumentWorkCycleStageNames: TStrings
    );
var
  Condition, Name: string;
begin

  Condition := '';

  for Name in SelectedDocumentWorkCycleStageNames do
  begin
    if Condition <> '' then
      Condition := Condition + ' OR ';

    Condition := Condition +
      '(' + CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN + ' = ' + QuotedStr(Name) + ')';
  end;

  if Condition <> '' then
    Condition := '(' + Condition + ')';

  if (FilterString <> '') and (Condition <> '') then
    FilterString := FilterString + ' AND ';
  FilterString := FilterString + Condition;

end;


{ TEmployeeDocumentsReferencFilterForm }

procedure TBaseDocumentsReferenceFilterForm.AssignFilterPanelData(
  const ColumnField: TcxGridDBColumn;
  FilterFieldControls: TFilterFieldControls;
  FilterPanelData: TFilterPanelData
);
begin

  inherited;
  
  if ColumnField.DataBinding.FieldName = CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN then
    FDocumentWorkCycleStageComboBox.ItemIndex :=
      (FilterPanelData.FilterValue as TVariant).Value;

end;


function TBaseDocumentsReferenceFilterForm.CreateAndFillDocumentWorkCycleStageComboBox(
  ParentControl: TWinControl
): TComboBox;
begin

  FDocumentWorkCycleStageComboBox := TComboBox.Create(ParentControl);
  FDocumentWorkCycleStageComboBox.Parent := ParentControl;
  FDocumentWorkCycleStageComboBox.Style := csDropDownList;
  
  FillDocumentWorkCycleStageComboBox(FDocumentWorkCycleStageComboBox);

  FDocumentWorkCycleStageComboBox.OnChange :=
    OnDocumentWorkCycleStageComboBoxChange;

  Result := FDocumentWorkCycleStageComboBox;
  
end;

function TBaseDocumentsReferenceFilterForm.CreateCurrentFilterPanelDataFor(
  const ColumnField: TcxGridDBColumn;
  FilterFieldControls: TFilterFieldControls): TFilterPanelData;
begin

  Result :=
    inherited
    CreateCurrentFilterPanelDataFor(
      ColumnField, FilterFieldControls
    );

  if ColumnField.DataBinding.FieldName = CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN then
    Result.FilterValue := TVariant.Create(FDocumentWorkCycleStageComboBox.ItemIndex);

end;

function TBaseDocumentsReferenceFilterForm.CreateFilterConditionsComboBox(
  ParentControl: TWinControl; FilterFieldValueControl: TControl;
  const Field: TcxGridDBColumn
): TComboBox;
begin

    Result :=
      inherited
      CreateFilterConditionsComboBox(
        ParentControl, FilterFieldValueControl, Field
      );
  
end;

function TBaseDocumentsReferenceFilterForm.CreateFilterFieldExpression(
  const ColumnField: TcxGridDBColumn;
  FilterConditionsComboBox: TComboBox;
  FilterFieldValueControl: TControl
): string;
begin

    Result :=
      inherited
      CreateFilterFieldExpression(
        ColumnField, FilterConditionsComboBox, FilterFieldValueControl
      );
  
end;

function TBaseDocumentsReferenceFilterForm.CreateFilterFieldValueControl(
  Parent: TWinControl;
  const Field: TcxGridDBColumn
): TControl;
begin

  if
    Field.DataBinding.FieldName = CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN
  then
    Result := CreateAndFillDocumentWorkCycleStageComboBox(Parent)

  else
    Result :=
      inherited
      CreateFilterFieldValueControl(Parent, Field);
  
end;

destructor TBaseDocumentsReferenceFilterForm.Destroy;
begin

  inherited;

end;

procedure TBaseDocumentsReferenceFilterForm.FillDocumentWorkCycleStageComboBox(
  DocumentWorkCycleStageComboBox: TComboBox);
var DocumentWorkCycleStageName: String;
begin

  for DocumentWorkCycleStageName in DocumentWorkCycleStageNames do begin

    DocumentWorkCycleStageComboBox.AddItem(
      DocumentWorkCycleStageName, nil
    );
    
  end;

  DocumentWorkCycleStageComboBox.ItemIndex := 0;

end;

function TBaseDocumentsReferenceFilterForm.GetDisableFilterConditionIndicesByField(
  const ColumnField: TcxGridDBColumn): TIntArray;
begin

  if ColumnField.DataBinding.FieldName <> CURRENT_DOCUMENT_WORK_CYCLE_STAGE_NAME_COLUMN
  then begin

    Result :=
      inherited GetDisableFilterConditionIndicesByField(ColumnField);

  end

  else begin

    Result :=
      TIntArray.Create(
        LESS_THAN_FILTER_COND_IDX,
        LESS_OR_EQUAL_THAN_FILTER_COND_IDX,
        GREATER_THAN_FILTER_COND_IDX,
        GREATER_OR_EQUAL_THAN_FILTER_COND_IDX,
        CONTAINS_FILTER_COND_IDX,
        NOT_CONTAINS_FILTER_COND_IDX,
        DATE_RANGE_FILTER_COND_IDX
      );

  end;
  
end;

function TBaseDocumentsReferenceFilterForm.GetDocumentWorkCycleStageNames: TStrings;
begin

  Result := FDocumentWorkCycleStageNames;
  
end;

function TBaseDocumentsReferenceFilterForm.GetSelectedDocumentWorkCycleStageNames: TStrings;
begin
  Result := FSelectedDocumentWorkCycleStageNames;
end;

class function TBaseDocumentsReferenceFilterForm.GetTableViewFilterFormStateClass: TTableViewFilterFormStateClass;
begin
  Result := TBaseDocumentReferenceFilterFormState;
end;

procedure TBaseDocumentsReferenceFilterForm.InternalSetLastState(
  ALastState: TTableViewFilterFormState);
var
  Filter: string;
begin
  inherited;

  btnCancelPrevFilter.Enabled := ALastState.FilterActivated;

  if Assigned(FSelectedDocumentWorkCycleStageNames) and (FSelectedDocumentWorkCycleStageNames.Count > 0) then
  begin
    if not ALastState.FilterActivated then
    begin
      Filter := '';
      AddSelectedDocumentWorkCycleStageNamesFilterConditionTo(Filter, SelectedDocumentWorkCycleStageNames);
      DataSet.Filter := Filter;
      DataSet.Filtered := True;
    end;
  end;

end;

procedure TBaseDocumentsReferenceFilterForm.OnDocumentWorkCycleStageComboBoxChange(
  Sender: TObject);
begin

  btnApply.Enabled := True;
  
end;

procedure TBaseDocumentsReferenceFilterForm.SaveCurrentState;
begin
  inherited;

  with FLastState as TBaseDocumentReferenceFilterFormState do begin

    FSelectedWorkCycleStageNames := FSelectedDocumentWorkCycleStageNames;

  end;


end;

procedure TBaseDocumentsReferenceFilterForm.SetDataSetFiltered(
  const Filtered: Boolean);
var
  Filter: string;
begin
  inherited;

  if not Filtered then
    Filter := ''
  else
    Filter := DataSet.Filter;

  AddSelectedDocumentWorkCycleStageNamesFilterConditionTo(Filter, SelectedDocumentWorkCycleStageNames);
  DataSet.Filter := Filter;
  DataSet.Filtered := True;

end;

procedure TBaseDocumentsReferenceFilterForm.SetDocumentWorkCycleStageNames(
  const Value: TStrings);
begin

  FDocumentWorkCycleStageNames := Value;
  
end;

procedure TBaseDocumentsReferenceFilterForm.SetSelectedDocumentWorkCycleStageNames(
  const Value: TStrings);
begin
  FSelectedDocumentWorkCycleStageNames := Value;
end;

{ TBaseDocumentReferenceFilterFormState }

function TBaseDocumentReferenceFilterFormState.Clone: TTableViewFilterFormState;
begin
  Result := inherited Clone;

  with Result as TBaseDocumentReferenceFilterFormState do begin

    FSelectedWorkCycleStageNames := Self.SelectedWorkCycleStageNames;
    
  end;
end;

function TBaseDocumentReferenceFilterFormState.ToDataSetFilter: String;
begin
  Result := inherited ToDataSetFilter;

  AddSelectedDocumentWorkCycleStageNamesFilterConditionTo(Result, SelectedWorkCycleStageNames);

end;

end.
