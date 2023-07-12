//
import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted = false
}

struct ContentView: View {
    @State private var isAddingTask = false
    @State private var taskTitle = ""
    @State private var tasks: [TaskItem] = []
    @State private var completedTasks: [TaskItem] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                                HStack {
                                    Text(task.title)
                                        .foregroundColor(task.isCompleted ? .green : .primary)
                                        .onTapGesture {
                                            markTaskAsCompleted(task)
                                        }
                                    if task.isCompleted {
                                        Spacer()
                                        Text("Выполнено")
                                            .foregroundColor(.green)
                                            .font(.footnote)
                                    }
                                }
                            }
                            .onDelete(perform: deleteTask)
            }
            .navigationTitle("Задачник")
            .navigationBarItems(trailing: Button(action: {
                isAddingTask = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isAddingTask, content: {
                NavigationView {
                    VStack {
                        TextField("Введите название задачи", text: $taskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button(action: addTask) {
                            Text("Добавить задачу")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .navigationTitle("Новая задача")
                    .navigationBarItems(trailing: Button(action: {
                        isAddingTask = false
                    }) {
                        Text("Отмена")
                    })
                }
            })
        }
    }

    private func addTask() {
        guard !taskTitle.isEmpty else {
            return
        }

        let newTask = TaskItem(title: taskTitle)
        tasks.append(newTask)
        taskTitle = ""
        isAddingTask = false
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func markTaskAsCompleted(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }

        tasks[index].isCompleted.toggle()

        if tasks[index].isCompleted {
            completedTasks.append(tasks[index])
        } else {
            completedTasks.removeAll(where: { $0.id == task.id })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
